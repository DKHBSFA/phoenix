# Fase 3: Alimentazione / Nutrizione

**Prerequisiti:** Fase 1 (profilo con peso), Fase 2 (allenamento con orari sessioni)
**Output:** Sezione nutrizione con TRE integrato, macro target, diario pasti, livelli digiuno funzionanti.

---

## 3.1 Concetto

Il pilastro nutrizionale in Phoenix NON è calorie counting. È:
1. **TRE (Time-Restricted Eating):** finestra alimentare 8-10h centrata sull'allenamento
2. **Proteine sufficienti:** 1.6-2.2 g/kg distribuite in 3+ pasti
3. **Digiuno progressivo:** 3 livelli con criteri oggettivi di avanzamento
4. **Diario semplice:** cosa hai mangiato + come ti sei sentito (non grammi/calorie)

---

## 3.2 Integrazione nel fasting screen esistente

Il `FastingScreen` attuale ha il timer. Va arricchito con:

### Tab structure (dentro FastingScreen)

Trasformare in `TabBarView` con 3 tab:
1. **Timer** — il timer digiuno attuale (già funzionante)
2. **Nutrizione** — macro target, finestra alimentare, diario pasti
3. **Livelli** — progressione livelli 1→2→3 con criteri

---

## 3.3 Tab Timer (miglioramenti)

### Livelli digiuno funzionanti

Il selector livello esiste ma non produce effetti. Collegare:

| Livello | Target ore | Descrizione |
|---------|-----------|-------------|
| 1 | 12-14h | Flessibilità metabolica baseline |
| 2 | 16-18h | Chetosi iniziale, segnale autofagico |
| 3 | 18-24h+ | Autofagia profonda (opzionale, avanzati) |

- Il timer mostra milestone sulla circonferenza: 12h, 14h, 16h, 18h, 24h
- Milestone raggiunto → notifica + haptic + opzionale TTS

### Refeeding journal

Quando l'utente termina il digiuno ("Termina digiuno"):
1. Mostrare dialog/sheet "Come è andato?"
2. Campi:
   - Tolleranza (1-5 stelle o slider)
   - Note libere ("cosa hai mangiato per primo?")
   - Energia percepita (1-5)
3. Salvare in `FastingSessions.refeedingNotes` e `toleranceScore`

---

## 3.4 Tab Nutrizione (NUOVO)

### Macro target calcolati

Basati su profilo utente:

```dart
// Dal protocollo sezione 4.1
double dailyProteinGrams(double weightKg, String tier) {
  switch (tier) {
    case 'beginner': return weightKg * 1.6;
    case 'intermediate': return weightKg * 1.8;
    case 'advanced': return weightKg * 2.2;
  }
}

double perMealProtein(double weightKg) {
  // 0.4-0.55 g/kg per pasto, minimo 3 pasti
  return weightKg * 0.4; // minimo per pasto
}
```

### UI Tab Nutrizione

**Card superiore: Target giornaliero**
- Proteine target: "128g" (basato su peso)
- Distribuzione: "3 pasti × ~43g proteine"
- Finestra alimentare: "10:00 - 18:00" (8h, centrata su orario allenamento)

**Card finestra alimentare**
- Barra orizzontale 24h con zona alimentare evidenziata (verde)
- Zona digiuno in grigio
- Orario primo pasto consigliato (entro 2h post-allenamento)
- Orario ultimo pasto

**Diario pasti semplice**

Non calorie counting. Solo:
- Tasto "+ Aggiungi pasto"
- Sheet con:
  - Ora (default: adesso)
  - Descrizione libera ("Pollo grigliato con riso e verdure")
  - Stima proteine: slider rapido (Bassa / Media / Alta / Molto alta)
    - Bassa = <15g, Media = 15-30g, Alta = 30-45g, Molto alta = >45g
  - Come ti senti? (emoji: 😊 😐 😴 🤢)
- Lista pasti del giorno sotto

### Nuova tabella DB: `meal_logs`

```dart
class MealLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get mealTime => dateTime()();
  TextColumn get description => text()();
  TextColumn get proteinEstimate => text()(); // 'low' / 'medium' / 'high' / 'very_high'
  TextColumn get feeling => text().withDefault(const Constant(''))(); // emoji o codice
  TextColumn get notes => text().withDefault(const Constant(''))();
}
```

### MealLogDao

```dart
- addMeal(MealLogsCompanion) → insert
- getMealsForDay(DateTime) → List<MealLog>
- watchMealsForDay(DateTime) → Stream
- deleteMeal(int id)
```

---

## 3.5 Tab Livelli (NUOVO)

### UI

3 card verticali, una per livello:

**Card Livello 1** (12-14h)
- Stato: ✅ Completato / 🔄 In corso / 🔒 Bloccato
- Descrizione: "Flessibilità metabolica baseline"
- Criteri avanzamento (checklist):
  - [ ] Peso stabile (±1kg) per 7 giorni
  - [ ] Energia soggettiva ≥ 3/5 per 5 digiuni consecutivi
  - [ ] HRV stabile (se disponibile)
  - [ ] Almeno 7 digiuni completati a questo livello

**Card Livello 2** (16-18h)
- Criteri avanzamento:
  - [ ] Glicemia stabile (se misurata)
  - [ ] Nessuna perdita muscolare (peso stabile o in calo lento)
  - [ ] Sonno > 7h per 7 giorni
  - [ ] Almeno 14 digiuni completati a questo livello
  - [ ] Tolleranza media ≥ 3/5

**Card Livello 3** (18-24h+)
- Nota: "Livello opzionale per utenti avanzati"
- Criteri: tutti livello 2 + performance allenamento stabile + HR riposo stabile

### Logica avanzamento

```dart
Future<bool> canAdvanceToLevel(int targetLevel) async {
  final currentLevel = targetLevel - 1;
  final sessions = await getSessionsByLevel(currentLevel);

  switch (targetLevel) {
    case 2:
      return sessions.length >= 7
        && sessions.where((s) => s.toleranceScore != null && s.toleranceScore! >= 3).length >= 5;
    case 3:
      return sessions.length >= 14
        && sessions.where((s) => s.toleranceScore != null && s.toleranceScore! >= 3).length >= 10;
  }
}
```

Quando criteri raggiunti → card diventa premibile → dialog conferma avanzamento.

---

## 3.6 Idratazione durante digiuno

### Reminder semplice

Nella schermata timer (quando digiuno attivo):
- Bottone piccolo "💧 Acqua" per loggare bicchiere d'acqua
- Counter giornaliero
- Nota: "Acqua + elettroliti (sodio, potassio, magnesio) — niente calorie"

Non serve una tabella dedicata, salvare in `FastingSessions` (aggiungere campo `waterCount` o usare notes).

---

## 3.7 File da creare/modificare

| File | Azione |
|------|--------|
| `lib/core/database/tables.dart` | Aggiungere `MealLogs` |
| `lib/core/database/database.dart` | Aggiungere tabella |
| `lib/core/database/daos/meal_log_dao.dart` | **Nuovo** |
| `lib/core/models/nutrition_calculator.dart` | **Nuovo** — calcolo macro target |
| `lib/features/fasting/fasting_screen.dart` | Ristrutturare con 3 tab |
| `lib/features/fasting/nutrition_tab.dart` | **Nuovo** — macro + diario pasti |
| `lib/features/fasting/levels_tab.dart` | **Nuovo** — progressione livelli |
| `lib/app/providers.dart` | Aggiungere `mealLogDaoProvider` |
| Regen DB | `dart run build_runner build` |

---

## 3.8 Verifica completamento

- [ ] Fasting screen ha 3 tab (Timer, Nutrizione, Livelli)
- [ ] Tab nutrizione mostra macro target basati su peso utente
- [ ] Finestra alimentare calcolata e visualizzata
- [ ] Diario pasti funzionante (aggiungi, visualizza, elimina)
- [ ] Stima proteine per pasto (slider rapido)
- [ ] Tab livelli mostra 3 card con criteri
- [ ] Avanzamento livello possibile quando criteri raggiunti
- [ ] Refeeding journal alla fine del digiuno
- [ ] Counter acqua durante digiuno
- [ ] `flutter analyze` 0 errors
