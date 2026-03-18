abstract class PromptTemplate {
  String get name;
  String render(Map<String, dynamic> context);
}

// ─── Qwen Chat Template Helper ─────────────────────────────────

/// Wraps system + user messages in Qwen chat template format.
/// Without this, the model doesn't know it's in a conversation and hallucinates.
/// Uses /no_think to disable Qwen3's reasoning mode (saves tokens and latency).
String _qwenPrompt({required String system, required String user}) {
  return '<|im_start|>system\n$system<|im_end|>\n'
      '<|im_start|>user\n/no_think\n$user<|im_end|>\n'
      '<|im_start|>assistant\n';
}

/// Strip any <think>...</think> blocks from model output (Qwen3 reasoning tokens).
String stripThinkingTokens(String text) {
  return text.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '').trim();
}

// ─── AI Coach Chat ───────────────────────────────────────────────

class ChatTemplate implements PromptTemplate {
  @override
  String get name => 'chat';

  @override
  String render(Map<String, dynamic> context) {
    final userMessage = context['user_message'] ?? '';
    final history = context['chat_history'] ?? '';
    final userData = context['user_data_summary'] ?? '';

    return _qwenPrompt(
      system: 'Sei un coach di longevità e performance chiamato Phoenix. '
          'Rispondi in italiano, max 100 parole. Sii diretto e motivante.',
      user: 'Dati utente:\n$userData\n\n'
          '${history.toString().isNotEmpty ? "Conversazione precedente:\n$history\n\n" : ""}'
          '$userMessage',
    );
  }
}

// ─── Fatigue Advisor ─────────────────────────────────────────────

class FatigueAdvisorTemplate implements PromptTemplate {
  @override
  String get name => 'fatigue_advisor';

  @override
  String render(Map<String, dynamic> context) {
    final rpeHistory = context['rpe_7d'] ?? [];
    final durations = context['durations_7d'] ?? [];
    final volumeHistory = context['volume_7d'] ?? [];
    final streak = context['streak'] ?? 0;
    final lastScore = context['last_duration_score'] ?? '';

    return _qwenPrompt(
      system: 'Sei un coach di performance. Analizza i dati di fatica e dai UNA sola raccomandazione. '
          'Rispondi in italiano, max 50 parole. '
          'Opzioni: "Riduci volume del X%", "Pronto per progressione", '
          '"Giorno di scarico consigliato", o "Continua così".',
      user: 'Dati ultimi 7 giorni:\n'
          '- RPE per sessione: $rpeHistory\n'
          '- Durate (min): $durations\n'
          '- Volume (set totali): $volumeHistory\n'
          '- Streak allenamento: $streak giorni\n'
          '- Ultimo duration score: $lastScore\n\n'
          'Qual è la tua raccomandazione?',
    );
  }
}

// ─── Fasting Pattern Advisor ─────────────────────────────────────

class FastingAdvisorTemplate implements PromptTemplate {
  @override
  String get name => 'fasting_advisor';

  @override
  String render(Map<String, dynamic> context) {
    final sessions = context['recent_fasting_sessions'] ?? [];
    final toleranceScores = context['tolerance_scores'] ?? [];
    final energyScores = context['energy_scores'] ?? [];
    final dayPatterns = context['day_of_week_patterns'] ?? '';
    final currentLevel = context['current_level'] ?? 1;

    return _qwenPrompt(
      system: 'Sei un coach di digiuno intermittente. Analizza i pattern e dai un insight. '
          'Rispondi in italiano, max 80 parole. Cerca: giorni migliori/peggiori, '
          'trend tolleranza, se pronto per avanzamento livello.',
      user: 'Sessioni recenti (30 giorni): $sessions\n'
          'Tolerance score: $toleranceScores\n'
          'Energy score: $energyScores\n'
          'Pattern settimanale: $dayPatterns\n'
          'Livello attuale: $currentLevel\n\n'
          'Qual è il tuo insight?',
    );
  }
}

// ─── Post-Set Coach Chat ────────────────────────────────────────

class PostSetCoachTemplate implements PromptTemplate {
  @override
  String get name => 'post_set_coach';

  @override
  String render(Map<String, dynamic> context) {
    final exerciseName = context['exercise_name'] ?? '';
    final setNumber = context['set_number'] ?? 1;
    final totalSets = context['total_sets'] ?? 1;
    final repsTarget = context['reps_target'] ?? 0;
    final tempoEcc = context['tempo_ecc'] ?? 0;
    final tempoCon = context['tempo_con'] ?? 0;
    final setHistory = context['set_history'] ?? '';
    final userMessage = context['user_message'] ?? '';

    return _qwenPrompt(
      system: 'Sei il coach Phoenix. L\'utente ha completato una serie di allenamento. '
          'Rispondi in italiano, max 3 frasi brevi. '
          'Estrai dal messaggio: rep completate, RPE (1-10), dolore (sì/no). '
          'Dopo la risposta, su una nuova riga scrivi ESATTAMENTE:\n'
          '[DATI: reps=<numero_o_null>, rpe=<numero_o_null>, dolore=<si_o_no>]',
      user: 'Esercizio: $exerciseName, serie $setNumber/$totalSets\n'
          'Target: $repsTarget rep. Tempo: ${tempoEcc}s ecc / ${tempoCon}s con.\n'
          'Serie precedenti: $setHistory\n\n'
          'Messaggio utente: $userMessage',
    );
  }
}

// ─── Physical Assessment (Onboarding) ────────────────────────────

class PhysicalAssessmentTemplate implements PromptTemplate {
  @override
  String get name => 'physical_assessment';

  @override
  String render(Map<String, dynamic> context) {
    final userName = context['user_name'] ?? '';
    final userSex = context['user_sex'] ?? '';
    final userAge = context['user_age'] ?? '';
    final userHeight = context['user_height'] ?? '';
    final userWeight = context['user_weight'] ?? '';
    final chatHistory = context['chat_history'] ?? '';
    final userMessage = context['user_message'] ?? '';

    return _qwenPrompt(
      system: 'Sei il coach Phoenix. Stai facendo l\'assessment fisico iniziale. '
          'Rispondi in italiano, max 3 frasi. Sii empatico ma diretto.\n\n'
          'Se l\'utente descrive un problema fisico:\n'
          '- Chiedi dove esattamente se non specificato\n'
          '- Chiedi da quanto tempo se non menzionato\n'
          '- Chiedi se ci sono altri problemi\n\n'
          'Quando hai abbastanza info, aggiungi su nuova riga:\n'
          '[ASSESSMENT: {"physical_limitations": [{"area": "<zona>", "type": "<tipo>", "severity": "<lieve/moderato/severo>"}], "done": true}]\n\n'
          'Zone: shoulder_right, shoulder_left, elbow_right, elbow_left, wrist_right, wrist_left, upper_back, lower_back, hip_right, hip_left, knee_right, knee_left, ankle_right, ankle_left.\n'
          'Tipi: pain, impingement, instability, stiffness, post_surgery, chronic.',
      user: 'Utente: $userName, $userSex, $userAge anni, $userHeight cm, $userWeight kg.\n'
          '${chatHistory.toString().isNotEmpty ? "Conversazione precedente:\n$chatHistory\n\n" : ""}'
          '$userMessage',
    );
  }
}

// ─── Training Program Generation (Onboarding) ───────────────────

class ProgramGenerationTemplate implements PromptTemplate {
  @override
  String get name => 'program_generation';

  @override
  String render(Map<String, dynamic> context) {
    final userName = context['user_name'] ?? '';
    final userSex = context['user_sex'] ?? '';
    final userAge = context['user_age'] ?? '';
    final userHeight = context['user_height'] ?? '';
    final userWeight = context['user_weight'] ?? '';
    final limitations = context['physical_limitations'] ?? '[]';
    final exerciseCategories = context['exercise_categories'] ?? '';

    return _qwenPrompt(
      system: 'Genera SOLO JSON, nessun altro testo. Formato:\n'
          '{"excluded_exercises": [], "level_overrides": {}, "notes": ""}\n\n'
          'Regole:\n'
          '- Schiena bassa → escludi deadlift, squat pesante\n'
          '- Spalle → escludi overhead press, dips\n'
          '- Ginocchia → escludi squat profondi, jump\n'
          '- level_overrides: abbassa a 1 le categorie coinvolte\n'
          '- notes: max 2 frasi in italiano',
      user: '$userName: $userSex, $userAge anni, $userHeight cm, $userWeight kg.\n'
          'Limitazioni: $limitations\n'
          'Categorie: $exerciseCategories',
    );
  }
}

// ─── Biomarker Insight ───────────────────────────────────────────

class BiomarkerInsightTemplate implements PromptTemplate {
  @override
  String get name => 'biomarker_insight';

  @override
  String render(Map<String, dynamic> context) {
    final currentPanel = context['current_panel'] ?? {};
    final previousPanel = context['previous_panel'] ?? {};
    final sex = context['sex'] ?? 'M';
    final phenoAge = context['pheno_age'] ?? 'N/A';
    final chronoAge = context['chrono_age'] ?? 'N/A';

    return _qwenPrompt(
      system: 'Sei un medico specializzato in longevità. Interpreta i biomarker in linguaggio semplice. '
          'Rispondi in italiano, max 100 parole. Includi:\n'
          '1. Variazioni significative vs pannello precedente\n'
          '2. Un aspetto positivo\n'
          '3. Un\'area da monitorare',
      user: 'Pannello attuale: $currentPanel\n'
          'Pannello precedente: $previousPanel\n'
          'Sesso: $sex\n'
          'PhenoAge: $phenoAge (età cronologica: $chronoAge)',
    );
  }
}
