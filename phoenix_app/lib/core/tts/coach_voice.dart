import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum CoachTrigger {
  morning,
  inactivity,
  duringWorkout,
  postWorkout,
  cardioWarmup,
  cardioWork,
  cardioRest,
  cardioZone2,
  cardioCooldown,
  cardioDone,
}

class CoachVoice {
  final FlutterTts _tts = FlutterTts();
  final _random = Random();

  bool enabled = true;
  bool _available = false;
  bool _initializing = false;
  double _volume = 1.0;
  double _speechRate = 0.5;

  double get volume => _volume;
  set volume(double value) {
    _volume = value;
    if (_available) _tts.setVolume(value);
  }

  double get speechRate => _speechRate;
  set speechRate(double value) {
    _speechRate = value;
    if (_available) _tts.setSpeechRate(value);
  }

  Future<void> init() async {
    if (_available || _initializing) return;
    _initializing = true;
    try {
      await _tts.setLanguage('it-IT');
      await _tts.setVolume(_volume);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      _available = true;
    } catch (e) {
      debugPrint('[CoachVoice] TTS not available on this platform: $e');
      _available = false;
    } finally {
      _initializing = false;
    }
  }

  Future<void> _ensureReady() async {
    if (!_available && !_initializing) await init();
    // Wait for in-flight init
    while (_initializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> speak(CoachTrigger trigger) async {
    if (!enabled) return;
    await _ensureReady();
    if (!_available) return;
    final phrases = _phrasesFor(trigger);
    final phrase = phrases[_random.nextInt(phrases.length)];
    await _tts.speak(phrase);
  }

  Future<void> speakCustom(String text) async {
    if (!enabled) return;
    await _ensureReady();
    if (!_available) return;
    await _tts.speak(text);
  }

  Future<void> stop() async {
    if (!_available) return;
    await _tts.stop();
  }

  Future<void> dispose() async {
    if (!_available) return;
    await _tts.stop();
  }

  List<String> _phrasesFor(CoachTrigger trigger) {
    switch (trigger) {
      case CoachTrigger.morning:
        return _morningPhrases;
      case CoachTrigger.inactivity:
        return _inactivityPhrases;
      case CoachTrigger.duringWorkout:
        return _workoutPhrases;
      case CoachTrigger.postWorkout:
        return _postWorkoutPhrases;
      case CoachTrigger.cardioWarmup:
        return _cardioWarmupPhrases;
      case CoachTrigger.cardioWork:
        return _cardioWorkPhrases;
      case CoachTrigger.cardioRest:
        return _cardioRestPhrases;
      case CoachTrigger.cardioZone2:
        return _cardioZone2Phrases;
      case CoachTrigger.cardioCooldown:
        return _cardioCooldownPhrases;
      case CoachTrigger.cardioDone:
        return _cardioDonePhrases;
    }
  }

  static const _morningPhrases = [
    'Buongiorno. Il protocollo ti aspetta.',
    'Oggi è il giorno giusto per migliorare.',
    'Quando pensi di allenarti?',
    'Il tuo corpo ti sta aspettando.',
    'Un nuovo giorno, una nuova opportunità.',
  ];

  static const _inactivityPhrases = [
    'Sono due giorni che non ti alleni. Tutto bene?',
    'Perché hai smesso di volerti bene?',
    'Il tuo corpo non si trasforma da solo.',
    'La costanza è tutto. Riprenditi.',
    'Ogni giorno perso è un passo indietro.',
  ];

  static const _workoutPhrases = [
    'Dai, un\'altra serie.',
    'Non mollare adesso.',
    'Concentrati. Forma perfetta.',
    'Ultimo set. Dai tutto.',
    'Spingi. Ce la fai.',
    'Mantieni il ritmo.',
    'Ogni rep conta.',
    'Più forte di ieri.',
  ];

  static const _postWorkoutPhrases = [
    'Grande sessione. Il corpo ringrazia.',
    'Un passo più vicino alla rinascita.',
    'Ottimo lavoro. Recupera bene.',
    'Sessione completata. Sei più forte.',
    'Il protocollo funziona. Continua così.',
  ];

  // ── Cardio-specific phrases ──────────────────────────────────

  static const _cardioWarmupPhrases = [
    'Riscaldamento. Mobilità leggera e attivazione.',
    'Prepara il corpo. Ritmo basso, movimenti ampi.',
    'Cinque minuti per attivarti. Niente fretta.',
  ];

  static const _cardioWorkPhrases = [
    'Vai! Massimo sforzo!',
    'Spingi! Dai tutto adesso!',
    'Intensità massima! Non mollare!',
    'Forza! Ogni secondo conta!',
    'Esplodi! Questo è il momento!',
  ];

  static const _cardioRestPhrases = [
    'Recupera. Respira profondamente.',
    'Recupero attivo. Cammina e respira.',
    'Bene. Lascia scendere il battito.',
    'Respira. Il prossimo round è tuo.',
  ];

  static const _cardioZone2Phrases = [
    'Zona 2. Ritmo costante, dovresti riuscire a parlare.',
    'Aerobico. Mantieni un passo regolare.',
    'Zona 2. Comfort, non sforzo. Brucia i grassi.',
    'Ritmo parlabile. Costante e rilassato.',
  ];

  static const _cardioCooldownPhrases = [
    'Defaticamento. Rallenta gradualmente.',
    'Stretching leggero e respirazione profonda.',
    'Bene. Lascia che il corpo si riprenda.',
  ];

  static const _cardioDonePhrases = [
    'Sessione completata! Grande lavoro cardio.',
    'Finito! Il cuore ti ringrazia.',
    'Ottima sessione. Ogni battito conta per la longevità.',
  ];
}
