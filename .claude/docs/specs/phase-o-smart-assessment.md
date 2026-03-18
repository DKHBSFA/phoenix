# Phase O: Smart Template Assessment

## Cosa

Migliorare il template assessment (fallback senza AI) per produrre valutazioni più accurate delle limitazioni fisiche, con severità graduata e azioni proporzionate (adatta / sostituisci / escludi).

## Perché

Il template attuale è un filtro grossolano: ~16 keyword, severità sempre "moderato", azione unica (escludi). Risultato: o esclude troppo o non rileva il problema.

## Cosa cambia

### 1. Dizionario keyword espanso (~80+ termini)

Nuovo modello a 3 livelli in `template_chat.dart`:

```dart
class BodyZoneDetector {
  // zona → lista di keyword/sinonimi
  static const zoneKeywords = {
    'lower_back': ['schiena', 'lombare', 'lombalgia', 'ernia', 'disco', 'discopatia',
                   'protrusione', 'sciatica', 'nervo sciatico', 'colonna', 'vertebra',
                   'rachide', 'sacro', 'coccige', 'zona lombare'],
    'upper_back': ['cervicale', 'collo', 'dorsale', 'cervicalgia', 'torcicollo',
                   'trapezio', 'dorsalgia', 'rigidità collo', 'colpo di frusta'],
    'shoulder_right': ['spalla destra'],
    'shoulder_left': ['spalla sinistra'],
    'shoulder': ['spalla', 'spalle', 'cuffia', 'cuffia dei rotatori', 'sovraspinato',
                 'lussazione', 'sublussazione', 'impingement', 'conflitto subacromiale',
                 'periartrite'],
    'knee_right': ['ginocchio destro'],
    'knee_left': ['ginocchio sinistro'],
    'knee': ['ginocchio', 'ginocchia', 'crociato', 'menisco', 'legamento', 'rotula',
             'condropatia', 'condromalacia', 'tendinite rotulea', 'LCA', 'LCP',
             'collaterale'],
    'hip_right': ['anca destra'],
    'hip_left': ['anca sinistra'],
    'hip': ['anca', 'anche', 'femore', 'coxartrosi', 'pubalgia', 'inguine',
            'trocanterite', 'borsite anca'],
    'ankle_right': ['caviglia destra'],
    'ankle_left': ['caviglia sinistra'],
    'ankle': ['caviglia', 'caviglie', 'tallone', 'achille', 'tendine d\'achille',
              'distorsione', 'fascite', 'fascite plantare', 'piede', 'piedi'],
    'elbow_right': ['gomito destro'],
    'elbow_left': ['gomito sinistro'],
    'elbow': ['gomito', 'epicondilite', 'gomito del tennista', 'epitrocleite',
              'gomito del golfista'],
    'wrist_right': ['polso destro'],
    'wrist_left': ['polso sinistro'],
    'wrist': ['polso', 'polsi', 'tunnel carpale', 'carpale', 'tendinite polso'],
  };
}
```

Matching: zone specifiche (dx/sx) matchano prima, poi zone generiche si applicano a entrambi i lati.

### 2. Severità estratta dal linguaggio

```dart
enum LimitationSeverity { mild, moderate, severe }
```

**Keyword di severità:**
- `severe`: operato, chirurgia, intervento, rottura, ernia, frattura, protesi, grave, fortissimo, insopportabile, non riesco
- `mild`: fastidio, leggero, lieve, ogni tanto, a volte, piccolo, pochino, leggermente
- `moderate` (default): dolore, male, problema, rigidità, blocco, infiammazione

**Keyword temporali (informative, salvate nel JSON):**
- Cronico: da anni, da mesi, da sempre, cronico, ricorrente, vecchio infortunio
- Acuto: ieri, settimana scorsa, recente, da poco, appena

### 3. Azioni graduate per severità

| Severità | Azione | Come |
|----------|--------|------|
| `mild` | **Adatta parametri** | Esercizio resta, ma: meno ROM (es. mezzo squat), RPE cap a 6, niente esplosivo |
| `moderate` | **Sostituisci** | Esercizio rimosso, sostituto sicuro dalla mappa |
| `severe` | **Escludi zona** | Tutti gli esercizi della zona esclusi, nessun sostituto |

### 4. Mappa sostituzioni (nuovo)

In `template_chat.dart`, nuova mappa per `moderate`:

```dart
static const _zoneSubstitutionMap = {
  'knee': {
    'Squat': 'Wall Sit (isometrico)',
    'Lunge': 'Step-Up basso',
    'Jump': null,  // nessun sostituto, escludi
    'Pistol': 'Single Leg Wall Sit',
  },
  'lower_back': {
    'Deadlift': 'Hip Hinge (scarico)',
    'Row': 'Seated Row',
    'Squat': 'Goblet Squat (leggero)',
  },
  'shoulder': {
    'Press': 'Landmine Press',
    'Dip': null,
    'Handstand': null,
  },
  // ...
};
```

**Nota:** I sostituti devono esistere nel DB exercises. Se non esistono, si comporta come `severe` (escludi).

### 5. Conversazione migliorata

Nuova fase `askSeverity` tra `askProblems` e `askDetails`:

```
enum _AssessmentPhase { askProblems, askSeverity, askDetails, askBloodwork, done }
```

Flusso:
1. **askProblems**: "Hai dolori o problemi fisici?" → rileva zone
2. **askSeverity**: Per ogni zona rilevata, chiede: "Il problema a [zona] è: leggero fastidio, dolore moderato, o grave (operazione/rottura)?" — MA solo se la severità non è già chiara dal testo originale
3. **askDetails**: "Altri problemi?" (come ora)
4. **askBloodwork**: come ora

### 6. Struttura dati migliorata

Il JSON delle limitazioni passa da:
```json
{"area": "knee_right", "type": "pain", "severity": "moderato"}
```
A:
```json
{
  "area": "knee_right",
  "type": "pain",
  "severity": "moderate",
  "action": "substitute",
  "temporal": "chronic",
  "details": "crociato",
  "paramOverrides": {"rpe_cap": 6, "no_explosive": true}
}
```

## File da toccare

| File | Cosa |
|------|------|
| `lib/core/llm/template_chat.dart` | Nuovo `BodyZoneDetector`, `_zoneSubstitutionMap`, severity parsing, `getExerciseModifications()` |
| `lib/features/onboarding/onboarding_screen.dart` | Nuovo `_AssessmentPhase.askSeverity`, keyword espanse, logica conversazione |
| `lib/core/models/app_settings.dart` | Aggiungere `exerciseModifications` (Map: exerciseId → {action, substitute, paramOverrides}) |
| `lib/core/models/settings_notifier.dart` | Salvare modifications oltre a excluded IDs |
| `lib/core/models/workout_generator.dart` | Leggere modifications: per `mild` → cap RPE/sets; per `moderate` → swap esercizio |
| `lib/core/models/exercise_rotator.dart` | Rispettare substitution map oltre a exclusion |

## Cosa NON cambia

- Il flusso LLM (quando disponibile) resta invariato — già gestisce sfumature
- La struttura del DB non cambia (limitazioni in settings JSON)
- L'UI della chat non cambia (stessi bubble)

## Come verifico

1. Onboarding senza AI, dico "ho il crociato destro operato" → severity `severe`, knee_right escluso
2. Dico "fastidio alla schiena ogni tanto" → severity `mild`, lower_back con RPE cap
3. Dico "dolore alla spalla" → severity `moderate`, sostituti proposti
4. Workout generato rispetta le modifiche (no esclusi, sostituti presenti, RPE cappato)
5. Confronto: stesse risposte di prima per "no problemi" e "ginocchio" generico
