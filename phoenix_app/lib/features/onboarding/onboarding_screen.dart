import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/design_tokens.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/database/database.dart';
import '../../core/database/tables.dart';
import '../../core/llm/model_manager.dart';
import '../../core/llm/prompt_templates.dart';
import '../../core/llm/template_chat.dart';
import '../../core/notifications/notification_scheduler.dart';
import 'widgets/brutalist_progress_bar.dart';
import 'widgets/wifi_warning_dialog.dart';

// ─── Steps ─────────────────────────────────────────────────────────

enum _Step { welcome, personalData, downloading, coachAssessment, confirm }
enum _AssessmentPhase { askProblems, askSeverity, askDetails, askBloodwork, done }

// ─── Rotating Messages ─────────────────────────────────────────────

const _downloadMessages = [
  'Il tuo coach AI vive nel telefono. Zero cloud, zero dati condivisi.',
  '1.2 GB per un coach che capisce il tuo corpo.',
  'BitNet: AI che gira su telefono senza GPU.',
  'Nessun abbonamento. Nessun server. Solo tu e il protocollo.',
];

// ─── Main Screen ───────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _Step _currentStep = _Step.welcome;

  // Step 2: Personal data
  final _nameController = TextEditingController();
  String? _sex;
  int? _birthYear;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  // Step 3: Download
  bool _downloadStarted = false;
  // Download is mandatory — no skip option

  // Step 4: Coach assessment
  final _chatMessages = <_ChatMsg>[];
  final _chatController = TextEditingController();
  final _chatScrollController = ScrollController();
  bool _chatProcessing = false;
  bool _assessmentDone = false;
  Map<String, dynamic>? _assessmentResult;
  _AssessmentPhase _assessmentPhase = _AssessmentPhase.askProblems;
  final _detectedLimitations = <Map<String, dynamic>>[];
  // Zones detected in current round awaiting severity clarification
  final _pendingSeverityZones = <String>[];

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  // ─── Navigation ──────────────────────────────────────────────────

  void _goTo(_Step step) {
    setState(() => _currentStep = step);
  }

  // Visible steps: welcome(0), personalData(1), coachAssessment(2), confirm(3)
  // downloading is hidden (runs in background)
  static const _visibleSteps = [
    _Step.welcome,
    _Step.personalData,
    _Step.coachAssessment,
    _Step.confirm,
  ];
  int get _stepIndex => _visibleSteps.indexOf(_currentStep).clamp(0, 3);
  int get _totalSteps => _visibleSteps.length;

  // ─── Step 2 validation ───────────────────────────────────────────

  bool get _personalDataValid {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length > 100) return false;
    if (_sex == null || _birthYear == null) return false;

    final height = double.tryParse(_heightController.text);
    if (height == null || height < 100 || height > 250) return false;

    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight < 30 || weight > 300) return false;

    return true;
  }

  // ─── Download logic ──────────────────────────────────────────────

  /// Start download in background. Called from INIZIA tap.
  /// Shows WiFi disclaimer if on mobile data, then starts download
  /// and navigates to personalData.
  Future<void> _startDownloadAndProceed() async {
    if (_downloadStarted) return;
    _downloadStarted = true;

    final manager = ref.read(modelManagerProvider);

    // Already downloaded — skip straight ahead
    if (manager.state.status == ModelDownloadStatus.ready) {
      _goTo(_Step.personalData);
      return;
    }

    // Check connectivity — show disclaimer if not on WiFi
    final connectivity = await Connectivity().checkConnectivity();
    final isWifi = connectivity.contains(ConnectivityResult.wifi);

    if (!isWifi && mounted) {
      final proceed = await WifiWarningDialog.show(context);
      if (!proceed) {
        _downloadStarted = false;
        // User declined — stay on welcome, can retry
        return;
      }
    }

    // Start download in background
    const manifest = ModelManifest.defaultManifest;
    manager.download(
      url: manifest.downloadUrl,
      expectedSha256:
          manifest.sha256Hash.isNotEmpty ? manifest.sha256Hash : null,
    );

    // Navigate to personal data while download runs
    _goTo(_Step.personalData);
  }

  /// Called after personalData "Avanti" — if model ready, go to assessment.
  /// Otherwise show download progress screen (model is mandatory).
  void _proceedAfterPersonalData() {
    final manager = ref.read(modelManagerProvider);
    if (manager.state.status == ModelDownloadStatus.ready) {
      _goTo(_Step.coachAssessment);
    } else {
      // Model not ready yet — show download progress, auto-advance when done
      _goTo(_Step.downloading);
    }
  }

  // ─── Coach chat logic ────────────────────────────────────────────

  void _openCoachChat() {
    final name = _nameController.text.trim();
    final greeting =
        'Ciao $name. Prima di iniziare, ho bisogno di sapere una cosa: '
        'hai problemi fisici, dolori o infortuni di cui devo tenere conto?';
    setState(() {
      _chatMessages.add(_ChatMsg(text: greeting, isUser: false));
    });
  }

  bool get _isLlmAvailable {
    final manager = ref.read(modelManagerProvider);
    return manager.state.status == ModelDownloadStatus.ready;
  }

  Future<void> _sendChatMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _chatProcessing) return;

    setState(() {
      _chatMessages.add(_ChatMsg(text: text, isUser: true));
      _chatController.clear();
      _chatProcessing = true;
    });
    _scrollToBottom();

    if (_isLlmAvailable) {
      await _generateLlmResponse(text);
    } else {
      // Template fallback: smart keyword-based response
      await Future.delayed(const Duration(milliseconds: 500));
      _addTemplateAssessmentResponse(text);
    }
    _scrollToBottom();
  }

  Future<void> _generateLlmResponse(String userMessage) async {
    final engine = ref.read(llmEngineProvider);
    final template = PhysicalAssessmentTemplate();

    // Build chat history
    final history = _chatMessages
        .map((m) => '${m.isUser ? "Utente" : "Coach"}: ${m.text}')
        .join('\n');

    // Compute age from birth year
    final age = _birthYear != null ? DateTime.now().year - _birthYear! : 0;

    try {
      final response = await engine.generate(
        template: template,
        context: {
          'user_name': _nameController.text.trim(),
          'user_sex': _sex == 'male' ? 'M' : 'F',
          'user_age': '$age',
          'user_height': _heightController.text.trim(),
          'user_weight': _weightController.text.trim(),
          'chat_history': history,
          'user_message': userMessage,
        },
        maxTokens: 256,
      );

      // Check for assessment completion
      final assessment = TemplateChat.parseAssessmentData(response);
      final displayText = TemplateChat.stripAssessmentData(response);

      // Validate LLM response is on-topic (not a generic coach message)
      final isOnTopic = _isAssessmentResponseRelevant(displayText, userMessage);

      if (isOnTopic && displayText.isNotEmpty) {
        setState(() {
          _chatMessages.add(_ChatMsg(text: displayText, isUser: false));
          if (assessment != null && assessment['done'] == true) {
            _assessmentDone = true;
            _assessmentResult = assessment;
            _assessmentPhase = _AssessmentPhase.done;
          }
          _chatProcessing = false;
        });
      } else {
        // LLM gave off-topic response — use smart template fallback
        _addTemplateAssessmentResponse(userMessage);
      }
    } catch (e) {
      _addTemplateAssessmentResponse(userMessage);
    }
  }

  bool _isAssessmentResponseRelevant(String response, String userMessage) {
    final lower = response.toLowerCase();
    // Off-topic signals: generic coach responses unrelated to injury assessment
    final offTopicPatterns = [
      'completato un allenamento',
      'inizia dalla tab',
      'primo passo verso',
      'hai raggiunto',
      'complimenti',
      'obiettivo',
    ];
    for (final pattern in offTopicPatterns) {
      if (lower.contains(pattern)) return false;
    }
    return true;
  }

  // ─── Expanded zone keyword map (~80+ terms) ──────────────────────
  // Specific side zones match first, then generic zones apply.

  static const _specificSideKeywords = <String, String>{
    'spalla destra': 'shoulder_right',
    'spalla sinistra': 'shoulder_left',
    'ginocchio destro': 'knee_right',
    'ginocchio sinistro': 'knee_left',
    'anca destra': 'hip_right',
    'anca sinistra': 'hip_left',
    'caviglia destra': 'ankle_right',
    'caviglia sinistra': 'ankle_left',
    'gomito destro': 'elbow_right',
    'gomito sinistro': 'elbow_left',
    'polso destro': 'wrist_right',
    'polso sinistro': 'wrist_left',
  };

  static const _genericZoneKeywords = <String, String>{
    // Lower back
    'schiena': 'lower_back', 'lombare': 'lower_back', 'lombalgia': 'lower_back',
    'ernia': 'lower_back', 'disco': 'lower_back', 'discopatia': 'lower_back',
    'protrusione': 'lower_back', 'sciatica': 'lower_back', 'nervo sciatico': 'lower_back',
    'colonna': 'lower_back', 'vertebra': 'lower_back', 'rachide': 'lower_back',
    'sacro': 'lower_back', 'coccige': 'lower_back', 'zona lombare': 'lower_back',
    // Upper back / neck
    'cervicale': 'upper_back', 'collo': 'upper_back', 'dorsale': 'upper_back',
    'cervicalgia': 'upper_back', 'torcicollo': 'upper_back', 'trapezio': 'upper_back',
    'dorsalgia': 'upper_back', 'colpo di frusta': 'upper_back',
    // Shoulder (generic)
    'spalla': 'shoulder', 'spalle': 'shoulder', 'cuffia': 'shoulder',
    'cuffia dei rotatori': 'shoulder', 'sovraspinato': 'shoulder',
    'lussazione': 'shoulder', 'sublussazione': 'shoulder', 'impingement': 'shoulder',
    'conflitto subacromiale': 'shoulder', 'periartrite': 'shoulder',
    // Knee (generic)
    'ginocchio': 'knee', 'ginocchia': 'knee', 'crociato': 'knee',
    'menisco': 'knee', 'legamento': 'knee', 'rotula': 'knee',
    'condropatia': 'knee', 'condromalacia': 'knee', 'tendinite rotulea': 'knee',
    'lca': 'knee', 'lcp': 'knee', 'collaterale': 'knee',
    // Hip (generic)
    'anca': 'hip', 'anche': 'hip', 'femore': 'hip', 'coxartrosi': 'hip',
    'pubalgia': 'hip', 'inguine': 'hip', 'trocanterite': 'hip', 'borsite anca': 'hip',
    // Ankle (generic)
    'caviglia': 'ankle', 'caviglie': 'ankle', 'tallone': 'ankle',
    'achille': 'ankle', "tendine d'achille": 'ankle', 'distorsione': 'ankle',
    'fascite': 'ankle', 'fascite plantare': 'ankle', 'piede': 'ankle', 'piedi': 'ankle',
    // Elbow (generic)
    'gomito': 'elbow', 'epicondilite': 'elbow', 'gomito del tennista': 'elbow',
    'epitrocleite': 'elbow', 'gomito del golfista': 'elbow',
    // Wrist (generic)
    'polso': 'wrist', 'polsi': 'wrist', 'tunnel carpale': 'wrist',
    'carpale': 'wrist', 'tendinite polso': 'wrist',
  };

  // ─── Severity keyword detection ──────────────────────────────────

  static const _severeKeywords = [
    'operato', 'chirurgia', 'intervento', 'rottura', 'frattura', 'protesi',
    'grave', 'fortissimo', 'insopportabile', 'non riesco',
  ];
  static const _mildKeywords = [
    'fastidio', 'leggero', 'lieve', 'ogni tanto', 'a volte',
    'piccolo', 'pochino', 'leggermente',
  ];
  static const _moderateKeywords = [
    'dolore', 'male', 'problema', 'rigidità', 'blocco', 'infiammazione',
  ];
  static const _chronicKeywords = [
    'da anni', 'da mesi', 'da sempre', 'cronico', 'ricorrente', 'vecchio infortunio',
  ];
  static const _acuteKeywords = [
    'ieri', 'settimana scorsa', 'recente', 'da poco', 'appena',
  ];

  /// Extract severity from user text. Returns null if ambiguous (needs asking).
  static String? _detectSeverity(String lower) {
    for (final kw in _severeKeywords) {
      if (lower.contains(kw)) return 'severe';
    }
    for (final kw in _mildKeywords) {
      if (lower.contains(kw)) return 'mild';
    }
    for (final kw in _moderateKeywords) {
      if (lower.contains(kw)) return 'moderate';
    }
    return null; // ambiguous
  }

  /// Extract temporal info from user text.
  static String? _detectTemporal(String lower) {
    for (final kw in _chronicKeywords) {
      if (lower.contains(kw)) return 'chronic';
    }
    for (final kw in _acuteKeywords) {
      if (lower.contains(kw)) return 'acute';
    }
    return null;
  }

  /// Detect body zones from text. Specific side keywords match first.
  static List<String> _detectZones(String lower) {
    final detected = <String>[];
    // Check specific side keywords first (longer phrases)
    for (final entry in _specificSideKeywords.entries) {
      if (lower.contains(entry.key) && !detected.contains(entry.value)) {
        detected.add(entry.value);
      }
    }
    // Then check generic zone keywords
    for (final entry in _genericZoneKeywords.entries) {
      if (lower.contains(entry.key)) {
        final zone = entry.value;
        // Skip if we already have a specific side for this zone
        if (detected.any((d) => d.startsWith(zone))) continue;
        if (!detected.contains(zone)) {
          detected.add(zone);
        }
      }
    }
    return detected;
  }

  static bool _isNegative(String lower) {
    return lower.contains('no') ||
        lower.contains('nessun') ||
        lower.contains('tutto bene') ||
        lower.contains('niente') ||
        lower.contains('sto bene') ||
        lower.contains('zero') ||
        lower.contains('nulla');
  }

  static bool _isAffirmative(String lower) {
    return lower.contains('sì') ||
        lower.contains('si') ||
        lower.contains('ok') ||
        lower.contains('va bene') ||
        lower.contains('certo') ||
        lower.contains('voglio') ||
        lower.contains('inizi') ||
        lower.contains('pront') ||
        lower.contains('andiamo') ||
        lower.contains('partiamo') ||
        lower.contains('dai');
  }

  void _addTemplateAssessmentResponse(String userMessage) {
    final lower = userMessage.toLowerCase();
    String response;

    switch (_assessmentPhase) {
      case _AssessmentPhase.askProblems:
        final detectedAreas = _detectZones(lower);

        if (detectedAreas.isNotEmpty) {
          final severity = _detectSeverity(lower);
          final temporal = _detectTemporal(lower);

          if (severity != null) {
            // Severity is clear from text — no need to ask
            for (final area in detectedAreas) {
              _detectedLimitations.add({
                'area': area,
                'type': 'pain',
                'severity': severity,
                'action': _OnboardingScreenState._actionForSeverityLabel(severity),
                if (temporal != null) 'temporal': temporal,
              });
            }
            final zoneNames = detectedAreas
                .map((a) => TemplateChat.zoneLabels[a] ?? a)
                .join(', ');
            final severityLabel = _severityLabelItalian(severity);
            response = 'Ho capito: $zoneNames — $severityLabel. '
                'Ci sono altri dolori o zone problematiche?';
            _assessmentPhase = _AssessmentPhase.askDetails;
          } else {
            // Severity ambiguous — need to ask
            _pendingSeverityZones.clear();
            _pendingSeverityZones.addAll(detectedAreas);
            final zoneNames = detectedAreas
                .map((a) => TemplateChat.zoneLabels[a] ?? a)
                .join(', ');
            response = 'Ho capito, problema a: $zoneNames.\n'
                'Come descriveresti il problema?\n'
                '1️⃣ Leggero fastidio (ogni tanto)\n'
                '2️⃣ Dolore moderato (costante o frequente)\n'
                '3️⃣ Grave (operazione, rottura, limitazione seria)';
            _assessmentPhase = _AssessmentPhase.askSeverity;
          }
        } else if (_isNegative(lower)) {
          response = 'Perfetto, nessun problema fisico. '
              'Vuoi caricare le tue analisi del sangue? '
              'Se le hai, posso personalizzare meglio il protocollo.';
          _assessmentPhase = _AssessmentPhase.askBloodwork;
        } else if (_isAffirmative(lower)) {
          response = 'Prima di partire: hai dolori, infortuni o problemi '
              'fisici di cui devo tenere conto? Anche cose piccole.';
        } else {
          response = 'Hai dolori o problemi fisici? '
              'Ad esempio: schiena, ginocchia, spalle, cervicale...';
        }

      case _AssessmentPhase.askSeverity:
        // User is responding to severity question
        String severity;
        if (lower.contains('1') || lower.contains('leggero') || lower.contains('fastidio') || lower.contains('lieve')) {
          severity = 'mild';
        } else if (lower.contains('3') || lower.contains('grave') || lower.contains('operato') || lower.contains('rottura') || lower.contains('chirurgia')) {
          severity = 'severe';
        } else {
          // Default to moderate (option 2, or any non-specific answer)
          severity = 'moderate';
        }
        final temporal = _detectTemporal(lower);
        for (final area in _pendingSeverityZones) {
          _detectedLimitations.add({
            'area': area,
            'type': 'pain',
            'severity': severity,
            'action': _OnboardingScreenState._actionForSeverityLabel(severity),
            if (temporal != null) 'temporal': temporal,
          });
        }
        final zoneNames = _pendingSeverityZones
            .map((a) => TemplateChat.zoneLabels[a] ?? a)
            .join(', ');
        final severityLabel = _severityLabelItalian(severity);
        _pendingSeverityZones.clear();
        response = 'OK: $zoneNames — $severityLabel. '
            'Ci sono altri dolori o zone problematiche?';
        _assessmentPhase = _AssessmentPhase.askDetails;

      case _AssessmentPhase.askDetails:
        final newAreas = _detectZones(lower)
            .where((z) => !_detectedLimitations.any((l) => l['area'] == z))
            .toList();

        if (newAreas.isNotEmpty) {
          final severity = _detectSeverity(lower);
          final temporal = _detectTemporal(lower);

          if (severity != null) {
            for (final area in newAreas) {
              _detectedLimitations.add({
                'area': area,
                'type': 'pain',
                'severity': severity,
                'action': _OnboardingScreenState._actionForSeverityLabel(severity),
                if (temporal != null) 'temporal': temporal,
              });
            }
            final zoneNames = newAreas
                .map((a) => TemplateChat.zoneLabels[a] ?? a)
                .join(', ');
            response = 'Aggiunto: $zoneNames — ${_severityLabelItalian(severity)}. Altro?';
          } else {
            _pendingSeverityZones.clear();
            _pendingSeverityZones.addAll(newAreas);
            final zoneNames = newAreas
                .map((a) => TemplateChat.zoneLabels[a] ?? a)
                .join(', ');
            response = 'Aggiunto: $zoneNames.\n'
                'Come descriveresti il problema?\n'
                '1️⃣ Leggero  2️⃣ Moderato  3️⃣ Grave';
            _assessmentPhase = _AssessmentPhase.askSeverity;
          }
        } else if (_isNegative(lower)) {
          final allZones = _detectedLimitations
              .map((l) {
                final label = TemplateChat.zoneLabels[l['area']] ?? l['area']!;
                final sev = _severityLabelItalian(l['severity'] as String);
                return '$label ($sev)';
              })
              .join(', ');
          response = 'OK, terrò conto di: $allZones. '
              'Adatterò gli esercizi di conseguenza.\n\n'
              'Vuoi caricare le analisi del sangue? '
              'Se le hai, posso personalizzare meglio il protocollo.';
          _assessmentPhase = _AssessmentPhase.askBloodwork;
        } else if (_isAffirmative(lower)) {
          final allZones = _detectedLimitations
              .map((l) {
                final label = TemplateChat.zoneLabels[l['area']] ?? l['area']!;
                final sev = _severityLabelItalian(l['severity'] as String);
                return '$label ($sev)';
              })
              .join(', ');
          response = 'Bene, adatterò il programma per: $allZones.\n\n'
              'Vuoi caricare le analisi del sangue?';
          _assessmentPhase = _AssessmentPhase.askBloodwork;
        } else {
          response = 'Ci sono altre zone con problemi? '
              'Se hai finito, dimmi pure "no".';
        }

      case _AssessmentPhase.askBloodwork:
        if (_isNegative(lower) || _isAffirmative(lower) && lower.contains('dopo') ||
            lower.contains('skip') || lower.contains('salta')) {
          _finishAssessment();
          response = 'Nessun problema. Potrai sempre caricarle dalla sezione Biomarker.\n\n'
              'Sono pronto a costruire il tuo piano Phoenix!';
        } else if (_isAffirmative(lower)) {
          _finishAssessment();
          response = 'Al momento puoi caricare le analisi dalla sezione Biomarker '
              'dopo il setup. Le terrò in considerazione per il protocollo.\n\n'
              'Intanto procediamo con il tuo piano Phoenix!';
        } else {
          response = 'Hai le analisi del sangue recenti? '
              'Rispondi sì o no — potrai sempre aggiungerle dopo.';
        }

      case _AssessmentPhase.done:
        response = 'L\'assessment è completo. Premi "Avanti" per procedere.';
    }

    setState(() {
      _chatMessages.add(_ChatMsg(text: response, isUser: false));
      _chatProcessing = false;
    });
  }

  static String _actionForSeverityLabel(String severity) => switch (severity) {
        'mild' => 'adapt',
        'moderate' => 'substitute',
        'severe' => 'exclude',
        _ => 'substitute',
      };

  static String _severityLabelItalian(String severity) => switch (severity) {
        'mild' => 'leggero',
        'moderate' => 'moderato',
        'severe' => 'grave',
        _ => 'moderato',
      };

  void _finishAssessment() {
    _assessmentPhase = _AssessmentPhase.done;
    _assessmentDone = true;
    _assessmentResult = {
      'physical_limitations': _detectedLimitations,
      'done': true,
    };
  }

  Future<void> _skipAssessment() async {
    setState(() {
      _assessmentDone = true;
      _assessmentResult = null;
    });
    _goTo(_Step.confirm);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: AnimDurations.fast,
          curve: AnimCurves.enter,
        );
      }
    });
  }

  // ─── Save and finish ─────────────────────────────────────────────

  Future<void> _saveAndFinish() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final dao = ref.read(userProfileDaoProvider);
      final settingsNotifier = ref.read(settingsProvider.notifier);
      final engine = ref.read(llmEngineProvider);
      final templateChat = ref.read(templateChatProvider);

      // 1. Save user profile
      final weightKg = double.parse(_weightController.text);
      await dao.saveProfile(UserProfilesCompanion(
        name: Value(_nameController.text.trim()),
        sex: Value(_sex!),
        birthYear: Value(_birthYear!),
        heightCm: Value(double.parse(_heightController.text)),
        weightKg: Value(weightKg),
        trainingTier: const Value('beginner'),
        equipment: const Value('bodyweight'),
        onboardingComplete: const Value(true),
      ));

      // 1b. Save initial weight as biomarker so it appears in the weight tab
      final biomarkerDao = ref.read(biomarkerDaoProvider);
      await biomarkerDao.addBiomarker(BiomarkersCompanion.insert(
        date: DateTime.now(),
        type: BiomarkerType.weight,
        valuesJson: jsonEncode({'kg': weightKg}),
      ));

      // 2. Build assessment data with graduated severity
      final limitations = _assessmentResult?['physical_limitations'] as List<dynamic>? ?? [];
      final limitationsJson = limitations.isNotEmpty ? jsonEncode(limitations) : null;
      final limitationMaps = limitations.cast<Map<String, dynamic>>();

      // Severe limitations: exclude entirely (legacy behavior)
      final severeZones = limitationMaps
          .where((l) => l['severity'] == 'severe')
          .map((l) => l['area'] as String)
          .toList();
      final excludedIds = await templateChat.getExcludedExerciseIds(severeZones);

      // All limitations: compute graduated modifications (adapt/substitute/exclude)
      final modifications = await templateChat.getExerciseModifications(limitationMaps);
      final modifiedJson = modifications.isNotEmpty
          ? jsonEncode(modifications.map((k, v) => MapEntry(k.toString(), v)))
          : null;

      // 3. Build chat transcript
      final transcript = _chatMessages
          .map((m) => '${m.isUser ? "Utente" : "Coach"}: ${m.text}')
          .toList();
      final chatTranscriptJson = jsonEncode(transcript);

      // 4. Generate training program — template-based (fast, reliable)
      final String generatedBy = 'template';
      final zones = limitationMaps.map((l) => l['area'] as String).toList();
      final String? trainingNotes = zones.isNotEmpty
          ? 'Programma adattato per limitazioni: ${zones.join(", ")}.'
          : null;
      final String? levelOverridesJson = null;

      // 5. Persist everything (including exercise modifications)
      await settingsNotifier.setPhysicalLimitations(
        limitationsJson: limitationsJson,
        excludedIds: excludedIds,
        modifiedJson: modifiedJson,
      );
      await settingsNotifier.saveOnboardingAssessment(
        limitationsJson: limitationsJson,
        excludedIds: excludedIds,
        chatTranscriptJson: chatTranscriptJson,
        levelOverridesJson: levelOverridesJson,
        trainingProgramNotes: trainingNotes,
        generatedBy: generatedBy,
      );

      // 6. Schedule 3-month reassessment reminder (non-critical)
      try {
        final notificationService = ref.read(notificationServiceProvider);
        final workoutDao = ref.read(workoutDaoProvider);
        final conditioningDao = ref.read(conditioningDaoProvider);
        final scheduler = NotificationScheduler(
            notificationService, workoutDao, conditioningDao);
        final updatedSettings = ref.read(settingsProvider);
        await scheduler.scheduleReassessmentReminder(
            updatedSettings.nextReassessmentDate);
      } catch (_) {
        // Notification scheduling is non-critical — don't block onboarding
      }

      // 7. Init LLM engine in background — don't block onboarding completion
      engine.initBestRuntime(templateChat: templateChat);

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          PhoenixRouter.home,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel salvataggio: $e'),
            action: SnackBarAction(
              label: 'Riprova',
              onPressed: _saveAndFinish,
            ),
          ),
        );
      }
    }
  }

  // ─── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            if (_currentStep != _Step.welcome)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.md,
                ),
                child: Column(
                  children: [
                    BrutalistProgressBar(
                      progress: (_stepIndex + 1) / _totalSteps,
                      isDark: isDark,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      'Passo ${_stepIndex + 1} di $_totalSteps',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SpaceMono',
                        color: context.phoenix.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: switch (_currentStep) {
                _Step.welcome => _buildWelcome(theme, isDark),
                _Step.personalData => _buildPersonalData(theme, isDark),
                _Step.downloading => _buildDownloading(theme, isDark),
                _Step.coachAssessment => _buildCoachAssessment(theme, isDark),
                _Step.confirm => _buildConfirm(theme, isDark),
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 1: Welcome ─────────────────────────────────────────────

  Widget _buildWelcome(ThemeData theme, bool isDark) {
    final subtitleColor = context.phoenix.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/phoenix_logo.png',
            width: 100,
            height: 100,
          )
              .animate()
              .fadeIn(duration: AnimDurations.slow)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          const SizedBox(height: Spacing.xl),
          Text(
            'PHOENIX',
            style: PhoenixTypography.h1.copyWith(
              color: isDark ? Colors.white : Colors.black,
              letterSpacing: 8,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: AnimDurations.normal),
          const SizedBox(height: Spacing.md),
          Text(
            'Protocollo di rinascita e longevità',
            style: theme.textTheme.bodyLarge?.copyWith(color: subtitleColor),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: AnimDurations.normal),
          const SizedBox(height: Spacing.xxl),
          SizedBox(
            width: double.infinity,
            height: TouchTargets.buttonHeight,
            child: _BrutalistButton(
              text: 'INIZIA',
              onTap: () {
                HapticFeedback.lightImpact();
                _startDownloadAndProceed();
              },
            ),
          ).animate().fadeIn(delay: 600.ms, duration: AnimDurations.normal),
        ],
      ),
    );
  }

  // ─── Step 2: Personal Data ───────────────────────────────────────

  static final _years = List.generate(71, (i) => 2010 - i);

  void _showYearPicker() {
    final initialIndex = _birthYear != null
        ? _years.indexOf(_birthYear!)
        : 25;
    final controller = FixedExtentScrollController(
      initialItem: initialIndex.clamp(0, _years.length - 1),
    );

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        int selected = _birthYear ?? _years[initialIndex.clamp(0, _years.length - 1)];
        int selectedIndex = initialIndex.clamp(0, _years.length - 1);
        return StatefulBuilder(
          builder: (ctx, setSheetState) => SafeArea(
            child: SizedBox(
              height: 280,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Annulla'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _birthYear = selected);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Conferma'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Selection highlight band
                        Container(
                          height: 42,
                          margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.white.withAlpha(40),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        ListWheelScrollView.useDelegate(
                          controller: controller,
                          itemExtent: 42,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (i) {
                            selected = _years[i];
                            setSheetState(() => selectedIndex = i);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: _years.length,
                            builder: (ctx, i) => Center(
                              child: Text(
                                '${_years[i]}',
                                style: TextStyle(
                                  fontSize: i == selectedIndex ? 22 : 18,
                                  fontWeight: i == selectedIndex
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: i == selectedIndex
                                      ? Colors.white
                                      : Colors.white.withAlpha(90),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalData(ThemeData theme, bool isDark) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Spacing.xl),
                Text('Dati base', style: theme.textTheme.headlineMedium),
                const SizedBox(height: Spacing.lg),

                // Name
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Come vuoi essere chiamato',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: Spacing.lg),

                // Sex
                Text('Sesso', style: theme.textTheme.titleSmall),
                const SizedBox(height: Spacing.sm),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'male', label: Text('Maschio')),
                    ButtonSegment(value: 'female', label: Text('Femmina')),
                  ],
                  selected: _sex != null ? {_sex!} : {},
                  emptySelectionAllowed: true,
                  onSelectionChanged: (s) {
                    if (s.isNotEmpty) setState(() => _sex = s.first);
                  },
                ),
                const SizedBox(height: Spacing.lg),

                // Birth year
                Text('Anno di nascita', style: theme.textTheme.titleSmall),
                const SizedBox(height: Spacing.sm),
                GestureDetector(
                  onTap: _showYearPicker,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Seleziona anno',
                    ),
                    child: Text(
                      _birthYear != null ? '$_birthYear' : 'Seleziona anno',
                      style: TextStyle(
                        fontSize: 16,
                        color: _birthYear != null
                            ? context.phoenix.textPrimary
                            : context.phoenix.textTertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.lg),

                // Height
                TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Altezza (cm)',
                    hintText: 'es. 175',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: Spacing.lg),

                // Weight
                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Peso (kg)',
                    hintText: 'es. 75.5',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: Spacing.xl),
              ],
            ),
          ),
        ),

        // Button
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.md,
          ),
          child: SizedBox(
            width: double.infinity,
            height: TouchTargets.buttonHeight,
            child: _BrutalistButton(
              text: 'Avanti',
              enabled: _personalDataValid,
              onTap: () {
                HapticFeedback.lightImpact();
                _proceedAfterPersonalData();
              },
            ),
          ),
        ),
      ],
    );
  }

  // ─── Step 3: Downloading ─────────────────────────────────────────

  Widget _buildDownloading(ThemeData theme, bool isDark) {
    final manager = ref.watch(modelManagerProvider);
    final state = manager.state;
    final subtitleColor = context.phoenix.textSecondary;

    // Auto-advance when download completes
    if (state.status == ModelDownloadStatus.ready) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentStep == _Step.downloading) {
          _goTo(_Step.coachAssessment);
          _openCoachChat();
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Status icon
          Icon(
            state.status == ModelDownloadStatus.error
                ? Icons.error_outline
                : Icons.downloading,
            size: 48,
            color: state.status == ModelDownloadStatus.error
                ? PhoenixColors.error
                : (isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: Spacing.xl),

          // Title
          Text(
            state.status == ModelDownloadStatus.error
                ? 'Scaricamento non riuscito'
                : 'Scaricando il coach AI',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.lg),

          // Progress bar
          if (state.status == ModelDownloadStatus.downloading ||
              state.status == ModelDownloadStatus.verifying)
            Column(
              children: [
                BrutalistProgressBar(
                  progress: state.progress,
                  isDark: isDark,
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        state.progressLabel,
                        style: PhoenixTypography.caption.copyWith(color: subtitleColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (state.speedLabel.isNotEmpty) ...[
                      const SizedBox(width: Spacing.sm),
                      Text(
                        '${state.speedLabel}  ${state.etaLabel}',
                        style: PhoenixTypography.caption.copyWith(color: subtitleColor),
                      ),
                    ],
                  ],
                ),
              ],
            ),

          const SizedBox(height: Spacing.xl),

          // Rotating messages
          if (state.status == ModelDownloadStatus.downloading)
            _RotatingMessage(messages: _downloadMessages),

          // Error message
          if (state.status == ModelDownloadStatus.error)
            Column(
              children: [
                Text(
                  state.errorMessage ??
                      'Il coach funzionerà in modalità base. Riprova dalle impostazioni.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: subtitleColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.lg),
                OutlinedButton(
                  onPressed: () {
                    // Retry download
                    setState(() => _downloadStarted = false);
                    _startDownloadAndProceed();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.phoenix.textPrimary,
                    side: BorderSide(color: context.phoenix.border),
                  ),
                  child: const Text('Riprova'),
                ),
              ],
            ),

          // Verifying
          if (state.status == ModelDownloadStatus.verifying)
            Text(
              'Verifica checksum...',
              style: theme.textTheme.bodyMedium?.copyWith(color: subtitleColor),
            ),

          const Spacer(),

          // Skip button — always available so the user is never stuck
          Padding(
            padding: const EdgeInsets.only(bottom: Spacing.lg),
            child: TextButton(
              onPressed: () {
                _goTo(_Step.coachAssessment);
                _openCoachChat();
              },
              child: Text(
                'Continua senza AI',
                style: PhoenixTypography.bodyMedium.copyWith(
                  color: subtitleColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 4: Coach Assessment ────────────────────────────────────

  Widget _buildCoachAssessment(ThemeData theme, bool isDark) {
    // Open coach chat on first build if not already opened
    if (_chatMessages.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openCoachChat());
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
          child: Row(
            children: [
              Text('Assessment fisico', style: theme.textTheme.titleLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.phoenix.border,
                    width: Borders.thin,
                  ),
                ),
                child: Text(
                  'AI',
                  style: PhoenixTypography.caption.copyWith(
                    color: context.phoenix.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Chat area
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
            itemCount: _chatMessages.length,
            itemBuilder: (context, i) {
              return _buildChatBubble(_chatMessages[i], isDark);
            },
          ),
        ),

        // Chat input
        if (!_assessmentDone)
          _buildChatInput(isDark),

        // Assessment done → next
        if (_assessmentDone)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: Spacing.sm,
            ),
            child: SizedBox(
              width: double.infinity,
              height: TouchTargets.buttonHeight,
              child: _BrutalistButton(
                text: 'Avanti',
                onTap: () => _goTo(_Step.confirm),
              ),
            ),
          ),

        // "No problems" shortcut
        if (!_assessmentDone)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
              vertical: Spacing.sm,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _skipAssessment,
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.phoenix.textPrimary,
                  side: BorderSide(color: context.phoenix.border),
                  padding: const EdgeInsets.symmetric(vertical: Spacing.smMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                ),
                child: const Text('NESSUN PROBLEMA'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChatBubble(_ChatMsg msg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(Spacing.smMd),
          decoration: BoxDecoration(
            color: msg.isUser
                ? (isDark ? PhoenixColors.darkOverlay : PhoenixColors.lightElevated)
                : (isDark ? PhoenixColors.darkElevated : PhoenixColors.lightSurface),
            border: Border.all(
              color: context.phoenix.border,
              width: msg.isUser ? Borders.thin : Borders.medium,
            ),
          ),
          child: Text(
            msg.text,
            style: PhoenixTypography.bodyMedium.copyWith(
              color: context.phoenix.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput(bool isDark) {
    final borderColor = context.phoenix.border;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.screenH,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: Borders.thin)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Descrivi il problema...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.input),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.smMd,
                  vertical: Spacing.sm,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendChatMessage(),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          SizedBox(
            width: TouchTargets.min,
            height: TouchTargets.min,
            child: Material(
              color: isDark ? Colors.white : Colors.black,
              child: InkWell(
                onTap: _chatProcessing ? null : _sendChatMessage,
                child: Center(
                  child: _chatProcessing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ─── Step 5: Confirm ─────────────────────────────────────────────

  Widget _buildConfirm(ThemeData theme, bool isDark) {
    final subtitleColor = context.phoenix.textSecondary;
    final name = _nameController.text.trim();
    final limitations = _assessmentResult?['physical_limitations'] as List<dynamic>? ?? [];
    final hasLimitations = limitations.isNotEmpty;

    String exclusionSummary = '';
    if (hasLimitations) {
      final zones = limitations.map((l) {
        final area = l['area'] as String;
        return TemplateChat.zoneLabels[area] ?? area;
      }).toList();
      exclusionSummary = zones.join(', ');
    }

    final coachMessage = hasLimitations
        ? 'Perfetto $name. Eviteremo gli esercizi che coinvolgono $exclusionSummary e partiremo dal livello 1. Sei pronto?'
        : 'Ottimo $name! Partiamo dal livello 1. Se qualcosa non va durante l\'allenamento, dimmelo.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/phoenix_logo.png',
            width: 72,
            height: 72,
          ),
          const SizedBox(height: Spacing.xl),
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.phoenix.border,
                width: Borders.medium,
              ),
            ),
            child: Text(
              coachMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: TouchTargets.buttonHeight,
            child: _saving
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _BrutalistButton(
                    text: 'INIZIA IL PROTOCOLLO',
                    onTap: _saveAndFinish,
                  ),
          ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}

// ─── Chat Message ──────────────────────────────────────────────────

class _ChatMsg {
  final String text;
  final bool isUser;
  const _ChatMsg({required this.text, required this.isUser});
}

// ─── Brutalist Primary Button ───────────────────────────────────────

class _BrutalistButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool enabled;

  const _BrutalistButton({
    required this.text,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = enabled
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? Colors.white24 : Colors.black26);
    final fg = isDark ? Colors.black : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: TouchTargets.buttonHeight,
      child: Material(
        color: bg,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Center(
            child: Text(
              text,
              style: PhoenixTypography.button.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Rotating Message Widget ───────────────────────────────────────

class _RotatingMessage extends StatefulWidget {
  final List<String> messages;
  const _RotatingMessage({required this.messages});

  @override
  State<_RotatingMessage> createState() => _RotatingMessageState();
}

class _RotatingMessageState extends State<_RotatingMessage> {
  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() => _index = (_index + 1) % widget.messages.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.phoenix.textSecondary;

    return AnimatedSwitcher(
      duration: AnimDurations.normal,
      child: Text(
        widget.messages[_index],
        key: ValueKey(_index),
        style: PhoenixTypography.bodyMedium.copyWith(
          color: color,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
