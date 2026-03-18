# Fase 1: Onboarding + Profilo Utente + Settings

**Prerequisiti:** Nessuno (prima fase)
**Output:** L'app al primo avvio chiede i dati utente. Esiste una schermata Settings. Il profilo è persistente nel DB.

---

## 1.1 Nuova tabella DB: `user_profiles`

La tabella `UserSettings` attuale è troppo generica (solo `settings_json`). Serve una tabella dedicata.

```dart
// In tables.dart — aggiungere

class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // Dati anagrafici
  TextColumn get sex => text()(); // 'male' / 'female'
  IntColumn get birthYear => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();

  // Livello e equipment
  TextColumn get trainingTier => text()(); // 'beginner' / 'intermediate' / 'advanced'
  TextColumn get equipment => text()(); // 'gym' / 'home' / 'bodyweight'

  // Self-test (opzionali)
  IntColumn get maxPushups => integer().nullable()();
  IntColumn get maxSquats => integer().nullable()();
  IntColumn get plankSeconds => integer().nullable()();
  IntColumn get restingHr => integer().nullable()();

  // Onboarding completato
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
}
```

Aggiungere `UserProfiles` alla lista tabelle in `database.dart`.

### DAO: `UserProfileDao`

```
- getProfile() → UserProfile? (primo record o null)
- saveProfile(UserProfilesCompanion) → insert o update
- isOnboardingComplete() → bool
- updateWeight(double kg) → aggiorna peso + timestamp
```

### Provider

```dart
final userProfileDaoProvider = Provider<UserProfileDao>((ref) {
  return UserProfileDao(ref.watch(databaseProvider));
});

// Stream del profilo (reactive)
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userProfileDaoProvider).watchProfile();
});
```

---

## 1.2 Flusso Onboarding

### Logica di avvio

In `main.dart` o `HomeScreen`, controllare `isOnboardingComplete()`:
- Se `false` → navigare a `OnboardingScreen` (push replacement, non può tornare indietro)
- Se `true` → mostrare dashboard normale

### OnboardingScreen (PageView con 6 step)

Usare `PageView` con `PageController`, indicatore di progresso in alto (dots o barra).

**Step 1: Benvenuto**
- Logo Phoenix (gold su dark)
- Titolo: "Benvenuto in Phoenix"
- Sottotitolo: "Il tuo percorso di ringiovanimento inizia qui"
- Tasto "Iniziamo" → next page

**Step 2: Dati personali**
- Sesso: `SegmentedButton` (Maschio / Femmina)
- Anno di nascita: `NumberPicker` o `DropdownButton` (range 1940-2010)
- Altezza (cm): `TextField` numerico
- Peso (kg): `TextField` numerico con decimale
- Tutti obbligatori, validazione inline

**Step 3: Esperienza allenamento**
- 3 card selezionabili (una sola):
  - **Principiante** — "Mai allenato o meno di 6 mesi"
  - **Intermedio** — "6 mesi - 2 anni di allenamento regolare"
  - **Avanzato** — "Più di 2 anni di allenamento strutturato"
- Sotto-selezione equipment (sempre 3 card):
  - **Palestra** — "Bilanciere, macchine, pesi liberi"
  - **Casa** — "Manubri, kettlebell, bande elastiche"
  - **Corpo libero** — "Nessun attrezzo"

**Step 4: Self-test (opzionale)**
- Titolo: "Test rapido (facoltativo)"
- Sottotitolo: "Ci aiuta a personalizzare meglio il tuo programma"
- 4 campi numerici:
  - Max push-up consecutive
  - Max squat consecutive
  - Plank hold (secondi)
  - Frequenza cardiaca a riposo (bpm)
- Tasto "Salta" visibile

**Step 5: Obiettivi**
- Non serve un input complesso. Mostrare il messaggio:
  - "Phoenix non ti chiede cosa vuoi ottenere. Il protocollo è uno solo: **ringiovanimento cellulare** attraverso allenamento, condizionamento e nutrizione."
  - "Forza, composizione corporea e benessere sono conseguenze, non obiettivi."
- Questo allinea con la filosofia del progetto (immortality goal)

**Step 6: Riepilogo + conferma**
- Mostrare dati inseriti in card riepilogativa
- Tier assegnato (calcolato da esperienza + self-test)
- Equipment selezionato
- Tasto "Inizia il tuo percorso" → salva profilo, marca onboarding completo, naviga a dashboard

### Algoritmo classificazione Tier

```
Se esperienza == 'principiante' → Tier 1 (Beginner)
Se esperienza == 'intermedio':
  Se push-up >= 20 AND squat >= 25 → Tier 2 (Intermediate)
  Altrimenti → Tier 1 (comunque, con nota "progressione rapida")
Se esperienza == 'avanzato':
  Se push-up >= 40 AND squat >= 40 AND plank >= 120s → Tier 3 (Advanced)
  Altrimenti → Tier 2
Se self-test non compilato → usare solo esperienza dichiarata
```

---

## 1.3 Schermata Settings

### Route: `/settings`

Aggiungere in `router.dart`:
```dart
static const settings = '/settings';
// case settings: return _buildRoute(const SettingsScreen());
```

### Accesso

Icona ingranaggio nell'AppBar della dashboard (HomeScreen), al posto del toggle tema attuale.

### Contenuto SettingsScreen

Usare `ListView` con sezioni:

**Sezione: Profilo**
- Card riepilogativa: nome tier, equipment, peso attuale, età
- Tasto "Modifica profilo" → apre dialog/sheet per modificare dati

**Sezione: Allenamento**
- Toggle "Spiegazione coach prima dell'esercizio" (default: ON)
  - Se ON: prima di ogni esercizio, coach TTS legge istruzioni + countdown 5s
  - Se OFF: parte subito con countdown 3s
- Toggle "Metronomo durante le serie" (default: OFF)
- Toggle "Vibrazione haptic completamento serie" (default: ON)

**Sezione: Aspetto**
- Selettore tema: Sistema / Chiaro / Scuro (SegmentedButton)
- (Il toggle attuale in dashboard viene rimosso)

**Sezione: Coach**
- Toggle "Coach vocale attivo" (default: ON, controlla TTS globale)
- Slider volume coach (0-100%)

**Sezione: Dati**
- "Esporta dati" (placeholder per ora)
- "Ripristina onboarding" (debug, resetta onboarding flag)

### Persistenza Settings

Usare la tabella `UserSettings` esistente con `settings_json`:

```json
{
  "coachExplanation": true,
  "metronome": false,
  "hapticFeedback": true,
  "themeMode": "dark",
  "coachVoiceEnabled": true,
  "coachVolume": 0.8
}
```

Provider:
```dart
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(databaseProvider));
});
```

`AppSettings` è un data class Dart con i campi sopra + `copyWith`.

---

## 1.4 Integrazione con app esistente

### HomeScreen
- Rimuovere toggle tema dalla AppBar
- Aggiungere icona Settings (`Icons.settings`) → naviga a `/settings`
- All'avvio, controllare onboarding → redirect se necessario

### Tema
- `themeModeProvider` legge da `settingsProvider` invece di default `ThemeMode.dark`

### Coach Voice
- Controllare `settingsProvider.coachVoiceEnabled` prima di ogni `speak()`
- Controllare `settingsProvider.coachVolume` per volume

---

## 1.5 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/database/tables.dart` | Aggiungere `UserProfiles` |
| `lib/core/database/database.dart` | Aggiungere tabella alla lista |
| `lib/core/database/daos/user_profile_dao.dart` | **Nuovo** — CRUD profilo |
| `lib/core/models/app_settings.dart` | **Nuovo** — data class settings |
| `lib/core/models/settings_notifier.dart` | **Nuovo** — StateNotifier per settings |
| `lib/features/onboarding/onboarding_screen.dart` | **Nuovo** — flusso 6 step |
| `lib/features/settings/settings_screen.dart` | **Nuovo** — schermata impostazioni |
| `lib/app/router.dart` | Aggiungere route `/onboarding`, `/settings` |
| `lib/app/providers.dart` | Aggiungere `userProfileDaoProvider`, `settingsProvider` |
| `lib/features/workout/home_screen.dart` | Check onboarding, icona settings |
| Regen DB | `dart run build_runner build` dopo modifica tabelle |

---

## 1.6 Verifica completamento

- [ ] Al primo avvio → schermata onboarding
- [ ] 6 step completabili senza crash
- [ ] Dati salvati nel DB (verificare con query)
- [ ] Al secondo avvio → dashboard direttamente
- [ ] Settings raggiungibile dalla dashboard
- [ ] Toggle tema funziona da settings
- [ ] Toggle coach funziona (TTS si silenzia)
- [ ] Profilo modificabile da settings
- [ ] `flutter analyze` 0 errors
