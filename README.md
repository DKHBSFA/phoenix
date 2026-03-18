# Phoenix

**Training. Conditioning. Nutrition. Longevity.**

Phoenix is an open-source Flutter app that integrates strength training, physical/mental conditioning, and nutrition into one evidence-based protocol — with a single objective: maximize longevity and cellular repair.

Hypertrophy and body composition are consequences, never targets. Autophagy and training are the means. Immortality is the why.

---

## What Phoenix Does

**7 days a week. Every day is training. Recovery is active, never passive.**

| Pillar | What it covers |
|--------|---------------|
| **Training** | Periodized strength programs (linear, DUP, block/Verkhoshansky), 80+ exercises across 5 categories, 3 equipment modes (gym, home gym, bodyweight), automated progression |
| **Conditioning** | Cold exposure (Søberg protocol), heat therapy, guided breathing (box, relaxation, custom), sleep tracking with regularity scoring, meditation |
| **Nutrition** | Time-restricted eating with progressive fasting (16:8 → prolonged), protein cycling by day type, 30+ foods across 4 longevity tiers, macro targets with carb cycling |
| **Biomarkers** | PhenoAge calculation (Levine 2018), full blood panel tracking, weight trends, supplement engine (Western + Russian + Chinese traditions) |
| **AI Coach** | On-device LLM (BitNet) with template fallback, post-workout reports, weekly summaries, inter-set RPE coaching, research feed from PubMed + Europe PMC |

### Smart Ring Integration

Optional [Colmi R10](https://colmi.com/) smart ring for automatic physiological data:

- Real-time HR, SpO2, HRV during workouts
- Sleep stage tracking with hypnogram visualization
- Morning HRV baseline (Plews SWC framework)
- Bayevsky Stress Index
- Step counting
- Auto-sync on app open

### Home Screen Widgets

Android (2x2 and 4x4) and iOS WidgetKit widgets showing protocol progress, ring data, and next action.

---

## Built On

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.29+ / Dart 3.7+ |
| State | Riverpod |
| Database | Drift (SQLite, type-safe) |
| UI Components | TDesign Flutter + custom Phoenix design tokens |
| AI | BitNet.cpp via dart:ffi (on-device, no cloud) |
| BLE | universal_ble (Colmi R10) |
| Charts | fl_chart |
| Audio | just_audio (metronome, tempo cues) |
| TTS | flutter_tts (Italian coach voice) |
| Notifications | flutter_local_notifications + WorkManager |

---

## Evidence Base

The Phoenix Protocol is built on **120+ verified studies** across three research traditions:

- **Western** — ACSM, NSCA, Schoenfeld, Helms, Wisløff
- **Russian** — Verkhoshansky, Seluyanov, Plews, Bayevsky
- **Chinese** — Traditional medicine integration for supplements (Astragalus, Cordyceps, Reishi)

No parameter without a source. No tradition excluded.

Full protocol with 120+ citations available in the app under the "Protocollo" section.

---

## Project Structure

```
phoenix_app/
├── lib/
│   ├── app/                  # Theme, design tokens, routing
│   ├── core/
│   │   ├── audio/            # Metronome, session audio
│   │   ├── background/       # WorkManager tasks
│   │   ├── database/         # Drift DB, DAOs, seeds
│   │   ├── llm/              # BitNet runtime, template chat, prompts
│   │   ├── models/           # Domain logic (periodization, nutrition, HRV, etc.)
│   │   ├── notifications/    # Scheduling, milestones
│   │   ├── research/         # PubMed fetcher, evaluator, protocol updater
│   │   ├── ring/             # Colmi R10 BLE protocol, signal processing
│   │   └── tts/              # Coach voice
│   ├── features/
│   │   ├── assessment/       # Periodic fitness tests (ACSM/Eurofit/McGill norms)
│   │   ├── biomarkers/       # Blood panel, PhenoAge, weight, supplements
│   │   ├── cardio/           # HIIT sessions (Tabata, Norwegian 4x4, Zone 2)
│   │   ├── coach/            # AI chat, reports, research feed
│   │   ├── conditioning/     # Cold, heat, meditation, sleep
│   │   ├── exercise/         # Exercise detail sheets, cards
│   │   ├── fasting/          # Timer, nutrition tab, level progression
│   │   ├── history/          # Unified session timeline
│   │   ├── hrv/              # HRV detail and baseline
│   │   ├── nutrition/        # Meal plans, food database
│   │   ├── onboarding/       # 5-step onboarding with AI assessment
│   │   ├── progressions/     # Visual exercise progression maps
│   │   ├── protocol/         # In-app scientific paper (6 chapters, 50+ DOIs)
│   │   ├── settings/         # Ring pairing, preferences
│   │   ├── today/            # Daily protocol view (6 cards + coach)
│   │   ├── training/         # Workout preview, session start
│   │   ├── widgets/          # Home screen widget logic
│   │   └── workout/          # Guided workout session with tempo tracking
│   └── shared/               # Reusable widgets
├── assets/
│   ├── exercises/            # 97 WebP exercise images
│   └── sounds/               # Audio files
└── tools/                    # Python scripts (image download)
```

---

## Getting Started

### Prerequisites

- Flutter 3.29+
- Dart 3.7+
- Android Studio or Xcode

### Build & Run

```bash
cd phoenix_app

# Get dependencies
flutter pub get

# Generate code (Drift, Riverpod, Freezed)
dart run build_runner build --delete-conflicting-outputs

# Run
flutter run
```

### AI Coach (Optional)

The AI coach works in two modes:

1. **Template mode** (default) — rule-based responses, no download needed
2. **BitNet mode** — on-device LLM, requires ~1.2GB model download (triggered from onboarding or settings)

No cloud API keys required. Everything runs locally.

---

## Protocol Overview

| Component | Beginner | Intermediate | Advanced |
|-----------|----------|-------------|----------|
| Periodization | Linear (4-week) | DUP (6+1 week) | Block/Verkhoshansky (4 blocks) |
| Fasting | 16:8 TRE | 18:6 + monthly 24h | 20:4 + quarterly 48-72h |
| Cold exposure | 30s start | +30s/week | 180s cap, 11min/week dose |
| Assessment | Every 4 weeks | Every 4 weeks | Every 4 weeks |
| Cardio | Zone 2 steady | Zone 2 + Tabata | Zone 2 + Norwegian 4x4 |

Week 0 calibration is mandatory for beginners. No max testing — submaximal estimation only (Epley/Brzycki).

---

## License

Open source. License TBD.

---

## Acknowledgments

Built with research from three scientific traditions and the conviction that aging is a problem to solve, not a fate to accept.

> *Rinascita dalle ceneri.*
