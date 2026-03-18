# Codebase Registry

**Last updated:** 2026-03-18 (Colmi R10 Full Integration: signal processing, sleep, sync, workout bio, home widgets)

This is my memory. I update it as I learn. I check it before making claims.

---

## Skills

| Name | Location | Purpose |
|------|----------|---------|
| Seurat | `.claude/skills/seurat/` | UI design system, wireframing, page layout, WCAG accessibility |
| Emmet | `.claude/skills/emmet/` | Testing, QA, tech debt audit, functional mapping, unit tests |
| Heimdall | `.claude/skills/heimdall/` | AI-specific security analysis, OWASP Top 10, credential detection |
| Ghostwriter | `.claude/skills/ghostwriter/` | SEO + GEO dual optimization, persuasive copywriting |
| Baptist | `.claude/skills/baptist/` | CRO orchestrator, A/B testing, funnel analysis |
| Orson | `.claude/skills/orson/` | Programmatic video generation, demo recording with audio |
| Scribe | `.claude/skills/scribe/` | Office documents (xlsx, docx, pptx) and PDF handling |
| Forge | `.claude/skills/forge/` | Meta-skill for creating, auditing, and maintaining skills |

---

## Components

| Name | Type | Location | Purpose |
|------|------|----------|---------|
| PhoenixApp | Flutter App | `phoenix_app/` | Main mobile app (iOS + Android) |
| HomeScreen | Screen | `phoenix_app/lib/features/workout/home_screen.dart` | Main shell: 4-tab nav (Oggi/Storico/Bio/Coach), PopScope back handling |
| TodayScreen | Screen | `phoenix_app/lib/features/today/today_screen.dart` | Protocol-first daily view: 6 protocol cards + coach message, progress bar |
| HistoryScreen | Screen | `phoenix_app/lib/features/history/history_screen.dart` | Unified timeline of all past sessions (workout/fasting/conditioning) |
| DailyProtocol | Model | `phoenix_app/lib/core/models/daily_protocol.dart` | Computes daily protocol state from DB: workout/fasting/nutrition/cold/meditation/sleep |
| ProtocolProgressBar | Widget | `phoenix_app/lib/features/today/widgets/protocol_progress_bar.dart` | Horizontal "N/6" progress bar for daily protocol |
| TrainingCard | Widget | `phoenix_app/lib/features/today/widgets/training_card.dart` | Today protocol card for workout with start button |
| NutritionCard | Widget | `phoenix_app/lib/features/today/widgets/nutrition_card.dart` | Today protocol card: protein progress, 3 meal plan, disclaimer gate, meal detail tap |
| MealDetailSheet | Widget | `phoenix_app/lib/features/nutrition/meal_detail_sheet.dart` | Bottom sheet: ingredients with scaled grams, cooking method, macro summary |
| MedicalDisclaimerDialog | Widget | `phoenix_app/lib/shared/widgets/medical_disclaimer_dialog.dart` | Modal medical disclaimer, checkbox acceptance, 90-day expiry |
| MealPlanGenerator | Model | `phoenix_app/lib/core/models/meal_plan_generator.dart` | Generates daily meal plan scaled by weight, protein cycling by day type |
| FoodDao | DAO | `phoenix_app/lib/core/database/daos/food_dao.dart` | Query food items by tier, search by name |
| MealTemplateDao | DAO | `phoenix_app/lib/core/database/daos/meal_template_dao.dart` | Query meal templates by day type |
| FoodSeed | Seed | `phoenix_app/lib/core/database/seed/food_seed.dart` | ~30 foods across 4 longevity tiers (verified protocol, 80+ sources) |
| MealTemplateSeed | Seed | `phoenix_app/lib/core/database/seed/meal_template_seed.dart` | 9 meal templates: 3 day types × 3 meals (training/normal/autophagy) |
| FastingCard | Widget | `phoenix_app/lib/features/today/widgets/fasting_card.dart` | Today protocol card for fasting status |
| ColdCard | Widget | `phoenix_app/lib/features/today/widgets/cold_card.dart` | Today protocol card for cold exposure with dose/strength alert |
| MeditationCard | Widget | `phoenix_app/lib/features/today/widgets/meditation_card.dart` | Today protocol card for meditation |
| SleepCard | Widget | `phoenix_app/lib/features/today/widgets/sleep_card.dart` | Today protocol card for sleep tracking |
| CoachPrompts | Model | `phoenix_app/lib/core/models/coach_prompts.dart` | Template coach messages: today screen (morning/afternoon/evening/rest/complete), inter-set RPE cues, protocol nudges, fasting cues |
| CoachMessage | Widget | `phoenix_app/lib/features/today/widgets/coach_message.dart` | Proactive coach message at bottom of Today screen |
| TrainingScreen | Screen | `phoenix_app/lib/features/training/training_screen.dart` | Training tab: today's workout preview, start button, recent sessions |
| WorkoutSessionScreen | Screen | `phoenix_app/lib/features/workout/workout_session_screen.dart` | Guided workout: inline exercise detail preview→countdown→brutalist tempo bar tracking→AI coach chat (or template form)→rest, receives WorkoutPlan |
| FastingScreen | Screen | `phoenix_app/lib/features/fasting/fasting_screen.dart` | 3-tab fasting hub: Timer (water counter, refeeding journal), Nutrizione (macro targets, meal diary), Livelli (progression) |
| NutritionTab | Screen | `phoenix_app/lib/features/fasting/nutrition_tab.dart` | Macro targets from profile, eating window, meal diary with protein estimates |
| LevelsTab | Screen | `phoenix_app/lib/features/fasting/levels_tab.dart` | Fasting level 1→2→3 progression with criteria checklist |
| BiomarkersScreen | Screen | `phoenix_app/lib/features/biomarkers/biomarkers_screen.dart` | 4-tab biomarker hub: Dashboard, Sangue, Peso, PhenoAge |
| ConditioningScreen | Screen | `phoenix_app/lib/features/conditioning/conditioning_screen.dart` | 4-tab conditioning hub: Freddo, Caldo, Meditazione, Sonno |
| ColdTab | Screen | `phoenix_app/lib/features/conditioning/cold_tab.dart` | Cold progression: weekly target, dose tracking, 6h strength alert, Søberg reminder, countdown timer |
| HeatTab | Screen | `phoenix_app/lib/features/conditioning/heat_tab.dart` | Heat exposure: timer + temperature + trend history |
| MeditationTab | Screen | `phoenix_app/lib/features/conditioning/meditation_tab.dart` | Guided breathing: box/relaxation/custom, animated circle, phase counter |
| SleepTab | Screen | `phoenix_app/lib/features/conditioning/sleep_tab.dart` | Sleep tracking: bedtime/wake input, quality stars, regularity score, 14-day barchart, protocol tips |
| ConditioningHistory | Widget | `phoenix_app/lib/features/conditioning/conditioning_history.dart` | Trend charts (LineChart 30gg) + stats (totali/streak/media/trend) per conditioning type |
| BreathingController | Model | `phoenix_app/lib/core/models/breathing_controller.dart` | Breathing cue logic: phases, presets (box 4-4-4-4, relaxation 4-6), tick state machine |
| ColdProgression | Model | `phoenix_app/lib/core/models/cold_progression.dart` | Cold exposure progression: 30s start, +30s/week, 180s cap, 11min weekly dose, 6h strength constraint |
| SleepScore | Model | `phoenix_app/lib/core/models/sleep_score.dart` | Sleep analysis: regularity (std dev bedtimes), average duration, target tracking, JSON serialization |
| CoachScreen | Screen | `phoenix_app/lib/features/coach/coach_screen.dart` | Report chips, streaming reports, AI chat (enabled when model downloaded), status badge (AI/template) |
| ModelDownloadCard | Widget | `phoenix_app/lib/features/coach/widgets/model_download_card.dart` | Download/pause/resume/delete model, progress bar, speed, ETA, checksum verification |
| ChatMessage | Widget | `phoenix_app/lib/features/coach/widgets/chat_message.dart` | Chat bubble (user/coach) with streaming cursor animation |
| AiInsightCard | Widget | `phoenix_app/lib/features/coach/widgets/ai_insight_card.dart` | Expandable AI insight card, auto-generates from LLM, hidden if LLM unavailable |
| ModelManager | Core | `phoenix_app/lib/core/llm/model_manager.dart` | Download with dio resume, SHA256 checksum, delete, progress stream, disk space check |
| ExerciseDetailSheet | Widget | `phoenix_app/lib/features/exercise/exercise_detail_sheet.dart` | Modal bottom sheet: hero, badges, stats grid, numbered steps, muscles. Static show() method |
| ExerciseCard | Widget | `phoenix_app/lib/features/exercise/widgets/exercise_card.dart` | Horizontal card: category thumbnail, name, muscle badges, level/reps meta |
| ExerciseHero | Widget | `phoenix_app/lib/features/exercise/widgets/exercise_hero.dart` | Category-colored 16:9 placeholder with centered icon |
| MuscleBadge | Widget | `phoenix_app/lib/features/exercise/widgets/muscle_badge.dart` | Primary/secondary muscle badge, static parse() helper |
| StatsGrid | Widget | `phoenix_app/lib/features/exercise/widgets/stats_grid.dart` | 3-column stats (sets, tempo, equipment) |
| NumberedSteps | Widget | `phoenix_app/lib/features/exercise/widgets/numbered_steps.dart` | Numbered step cards from executionCues, static parseSteps() |
| TemplateChat | Core | `phoenix_app/lib/core/llm/template_chat.dart` | Rule-based chat engine: intent detection (7 categories), DB-backed contextual responses in Italian |
| ActivityRings | Widget | `phoenix_app/lib/features/workout/widgets/activity_rings.dart` | 3 concentric activity rings (CustomPainter), animated fill (easeOutCubic), Phoenix pillar colors |
| ActivityRingsData | Model | `phoenix_app/lib/core/models/activity_rings_data.dart` | Dashboard data: ring progress, OneBigThing priority logic, DashboardStats (PhenoAge/peso/streak/sonno) |
| ReportGenerator | Model | `phoenix_app/lib/core/models/report_generator.dart` | Template-based reports: post-workout, weekly, fasting. Replaceable by LLM when available |
| ProgressionsScreen | Screen | `phoenix_app/lib/features/progressions/progressions_screen.dart` | Visual progression maps per category (DB-backed) |
| PhoenixDatabase | Core | `phoenix_app/lib/core/database/database.dart` | Drift/SQLite database (v4, auto-seeds exercises) |
| MealLogDao | DAO | `phoenix_app/lib/core/database/daos/meal_log_dao.dart` | Meal logging: add/watch/delete meals by day |
| NutritionCalculator | Model | `phoenix_app/lib/core/models/nutrition_calculator.dart` | Protein targets by tier/weight, eating window, level descriptions |
| MacroTargets | Model | `phoenix_app/lib/core/models/nutrition_calculator.dart` | Full macro targets by day type: carb cycling (4.5/3.5/2.5 g/kg), fat, fiber, calories |
| DownloadExerciseImages | Tool | `phoenix_app/tools/download_exercise_images.py` | Wger API → 97 WebP exercise images in assets/exercises/, with caching + fallback |
| ExerciseDao | DAO | `phoenix_app/lib/core/database/daos/exercise_dao.dart` | Exercise queries: by category/level/equipment, progression chains |
| ExerciseSeed | Seed | `phoenix_app/lib/core/database/seed/exercise_seed.dart` | ~80 exercises across 5 categories × 3 equipment types, with rich instructions (description, errors, breathing, variants) |
| EquipmentOverrideNotifier | Model | `phoenix_app/lib/core/models/workout_generator.dart` | StateNotifier for session equipment override (bodyweight toggle) |
| WorkoutGenerator | Model | `phoenix_app/lib/core/models/workout_generator.dart` | Day-of-week schedule → WorkoutPlan with tier-based params |
| WorkoutPlan | Model | `phoenix_app/lib/core/models/workout_plan.dart` | Data classes: WorkoutPlan, PlannedExercise |
| PostSetCoachTemplate | Template | `phoenix_app/lib/core/llm/prompt_templates.dart` | LLM prompt for post-set coach chat: extracts reps, RPE, pain from user message |
| LlmEngine | Core | `phoenix_app/lib/core/llm/llm_engine.dart` | LLM orchestrator: auto-select runtime (BitNet vs template), benchmark, generate + generateStream, inactivity unload |
| BitnetRuntime | Core | `phoenix_app/lib/core/llm/llm_runtime.dart` | bitnet.cpp FFI wrapper: load/unload/infer/streamStart/streamNext/streamDone via dart:ffi |
| AudioEngine | Core | `phoenix_app/lib/core/audio/audio_engine.dart` | Metronome, beeps, session audio |
| NotificationService | Core | `phoenix_app/lib/core/notifications/notification_service.dart` | Fasting milestones, workout reminders, cancelNotification, showNow |
| NotificationScheduler | Core | `phoenix_app/lib/core/notifications/notification_scheduler.dart` | Schedule/cancel workout + conditioning reminders based on settings |
| ProgressionDao | DAO | `phoenix_app/lib/core/database/daos/progression_dao.dart` | Progression history + 2-session criteria check for exercise advancement |
| ProgressionCheckResult | Model | `phoenix_app/lib/core/models/progression_check.dart` | Data class for exercise progression check results |
| BackgroundTasks | Core | `phoenix_app/lib/core/background/background_tasks.dart` | WorkManager callback: inactivity check (24h), conditioning reminder (12h) |
| DurationScoreCalculator | Model | `phoenix_app/lib/core/models/duration_score.dart` | Workout duration scoring (green/yellow/red) |
| RestTimes | Model | `phoenix_app/lib/core/models/rest_times.dart` | Adaptive rest time calculation |
| CoachVoice | Core | `phoenix_app/lib/core/tts/coach_voice.dart` | TTS motivational coach (italian, 4 triggers) |
| DesignTokens | Config | `phoenix_app/lib/app/design_tokens.dart` | Spacing, Radii, AnimDurations, AnimCurves, PhoenixColors (pillar colors, dark/light themes), PhoenixTypography, CardTokens |
| PhoenixTDTheme | Config | `phoenix_app/lib/app/phoenix_theme.dart` | TDesign ↔ Phoenix bridge: TDThemeData (light/dark), PhoenixPillarColors ThemeExtension, PhoenixResourceDelegate (Italian i18n) |
| PhoenixSwitchTile | Widget | `phoenix_app/lib/shared/widgets/phoenix_switch_tile.dart` | ListTile + TDSwitch wrapper, drop-in SwitchListTile replacement with external state management |
| SleepEnvironment | Model | `phoenix_app/lib/core/models/sleep_environment.dart` | Sleep config: target bedtime/wake, cutoff toggles (blue light/caffeine/temperature), cutoff calculations |
| SleepCoach | Model | `phoenix_app/lib/core/models/sleep_environment.dart` | Evidence-based evening tips: quality trend, regularity, cutoff reminders, priority-sorted |
| SupplementEngine | Model | `phoenix_app/lib/core/models/supplement_engine.dart` | Trilingual biomarker-triggered supplement engine: Western (D3/Omega-3/creatine/iron/Mg/collagen/NMN), Russian (Rhodiola/Ecdysterone/Schisandra), Chinese (Astragalus/Cordyceps/Reishi), anti-recs (Resveratrolo/Eleuthero/Meldonium), cycling rules |
| SupplementSection | Widget | `phoenix_app/lib/features/biomarkers/widgets/supplement_card.dart` | Expandable supplement cards with priority, dose, timing, exit criteria, anti-recommendations, missing markers |
| ProtocolCardShell | Widget | `phoenix_app/lib/shared/widgets/protocol_card_shell.dart` | Shared card shell for Today screen protocol cards: title, completed icon, surface/border, child content |
| PhoenixThemeContext | Extension | `phoenix_app/lib/app/design_tokens.dart` | `context.phoenix.*` extension resolving dark/light colors (textPrimary/Secondary/Tertiary, bg, surface, elevated, overlay, border, borderStrong, borderHeavy) |
| PhenoAgeCalculator | Model | `phoenix_app/lib/core/models/phenoage_calculator.dart` | Levine 2018 PhenoAge formula (9 biomarkers + age → biological age) |
| BiomarkerReferenceRanges | Model | `phoenix_app/lib/core/models/biomarker_reference_ranges.dart` | Reference ranges per sesso, marker definitions, sections for blood panel form |
| BiomarkerAlerts | Model | `phoenix_app/lib/core/models/biomarker_alerts.dart` | Protocol-based alert logic (testosterone/ferritina/hsCRP/linfociti/cortisolo/glicemia) |
| BloodPanelForm | Screen | `phoenix_app/lib/features/biomarkers/blood_panel_form.dart` | Full blood panel input form (base+extended, collapsible sections, alert dialog) |
| BiomarkerDashboardTab | Screen | `phoenix_app/lib/features/biomarkers/biomarker_dashboard_tab.dart` | Overview: PhenoAge hero card, marker grid with sparklines, weight summary |
| PhenoAgeTab | Screen | `phoenix_app/lib/features/biomarkers/phenoage_tab.dart` | PhenoAge calculator, history chart, missing markers checklist |
| WeightTab | Screen | `phoenix_app/lib/features/biomarkers/weight_tab.dart` | Weight trend, 7-day moving average, BMI, quick add |
| AssessmentScreen | Screen | `phoenix_app/lib/features/assessment/assessment_screen.dart` | Periodic assessment: 5 validated tests (pushup/wall sit/plank/sit&reach/Cooper), body measurements, history with trend charts, scoring (ACSM/Eurofit/McGill norms) |
| AssessmentBanner | Widget | `phoenix_app/lib/features/today/widgets/assessment_banner.dart` | Today screen banner: shows when assessment is due (every 4 weeks), links to assessment screen |
| AssessmentScoring | Model | `phoenix_app/lib/core/models/assessment_scoring.dart` | Scoring logic: age/sex-adjusted norms (ACSM push-up, Eurofit wall sit/sit&reach, McGill plank, Cooper VO2max), comparison deltas |
| AssessmentDao | DAO | `phoenix_app/lib/core/database/daos/assessment_dao.dart` | CRUD assessments, isAssessmentDue (28-day check), daysUntilDue, trend queries |
| ResearchFetcher | Core | `phoenix_app/lib/core/research/research_fetcher.dart` | PubMed E-utilities + Europe PMC API fetcher, 12 Phoenix keywords, dedup by DOI/title, max 20/session |
| ResearchEvaluator | Core | `phoenix_app/lib/core/research/research_evaluator.dart` | LLM or keyword-heuristic evaluation: summary, impact, area, update proposal detection |
| ProtocolUpdater | Core | `phoenix_app/lib/core/research/protocol_updater.dart` | Monthly report generation, approve/reject proposals, protocol never changes automatically |
| ResearchFeedDao | DAO | `phoenix_app/lib/core/database/daos/research_feed_dao.dart` | CRUD research papers, watchUnread, watchPendingUpdates, dedup by DOI/title |
| ResearchFeedCard | Widget | `phoenix_app/lib/features/coach/widgets/research_feed_card.dart` | Coach screen card: unread count badge, expandable paper list with impact/source badges |
| ProtocolUpdateSheet | Widget | `phoenix_app/lib/features/coach/protocol_update_sheet.dart` | Bottom sheet: pending update proposals, approve/reject buttons per proposal |
| OnboardingScreen | Screen | `phoenix_app/lib/features/onboarding/onboarding_screen.dart` | 5-step onboarding: welcome→dati base→download AI→coach assessment→conferma. Auto-downloads model, WiFi check, LLM chat or template fallback for physical assessment |
| BrutalistProgressBar | Widget | `phoenix_app/lib/features/onboarding/widgets/brutalist_progress_bar.dart` | Reusable 2px border progress bar, left-to-right fill |
| WifiWarningDialog | Widget | `phoenix_app/lib/features/onboarding/widgets/wifi_warning_dialog.dart` | Modal: warns about 1.2GB download on mobile data, continue/wait options |
| PhysicalAssessmentTemplate | Template | `phoenix_app/lib/core/llm/prompt_templates.dart` | LLM prompt for onboarding physical assessment: extracts area/type/severity, outputs [ASSESSMENT: JSON] |
| ProtocolChapters | Model | `phoenix_app/lib/core/models/protocol_chapters.dart` | Structured protocol paper: 6 chapters, 28 sections, ~50 DOI citations, Italian text |
| ProtocolPaperScreen | Screen | `phoenix_app/lib/features/protocol/protocol_paper_screen.dart` | In-app scientific paper: expandable chapter cards, rich text with bold, DOI chips with copy-to-clipboard |
| PeriodizationEngine | Model | `phoenix_app/lib/core/models/periodization_engine.dart` | Linear (beginner, 4-week), DUP (intermediate, 6+1 week), Block/Verkhoshansky (advanced, 4 blocks) periodization with deload triggers |
| MovementRoutineGenerator | Model | `phoenix_app/lib/core/models/movement_routine.dart` | Dynamic warmup, stability work, static/PNF cool-down routines with 5-10 min durations |
| Week0Generator | Model | `phoenix_app/lib/core/models/week0_generator.dart` | 6-session familiarization plan (Fitts & Posner + Bernstein motor learning), RPE 4-6, 2×12 |
| ExerciseRotator | Model | `phoenix_app/lib/core/models/exercise_rotator.dart` | Mesocyclic exercise rotation with ≥70% novelty, locked exercises, deterministic selection |
| CardioPlan | Model | `phoenix_app/lib/core/models/cardio_plan.dart` | Data classes for structured cardio: CardioPlan, HiitRound with modality/work/rest |
| CardioProtocols | Model | `phoenix_app/lib/core/models/cardio_protocols.dart` | Tabata (Tabata 1996), Norwegian 4×4 (Wisløff 2007), Zone 2 steady state protocols |
| HrZones | Model | `phoenix_app/lib/core/models/hr_zones.dart` | 5-zone HR calculator with protocol-specific targets per cardio type |
| HrvEngine | Model | `phoenix_app/lib/core/models/hrv_engine.dart` | LnRMSSD baseline, Plews SWC framework, Bayevsky Stress Index, Shlyk Type IV, recovery recommendations |
| CardioSessionScreen | Screen | `phoenix_app/lib/features/cardio/cardio_session_screen.dart` | Timer-driven HIIT/Zone 2 session with round tracking, RPE, HR zone display |
| HrvDetailScreen | Screen | `phoenix_app/lib/features/hrv/hrv_detail_screen.dart` | HRV detail view: readings history, baseline trend, recovery status |
| Week0Banner | Widget | `phoenix_app/lib/features/today/widgets/week0_banner.dart` | Today screen card for Week 0 familiarization: session dots, progress, skip option |
| CardioDao | DAO | `phoenix_app/lib/core/database/daos/cardio_dao.dart` | CRUD for cardio sessions: add, watch, range queries, count by protocol |
| MesocycleDao | DAO | `phoenix_app/lib/core/database/daos/mesocycle_dao.dart` | CRUD for mesocycle state and exercise assignments, previous selections lookback |
| HrvDao | DAO | `phoenix_app/lib/core/database/daos/hrv_dao.dart` | CRUD for HRV readings: recent, baseline (14), today, watch stream |
| Week0Dao | DAO | `phoenix_app/lib/core/database/daos/week0_dao.dart` | CRUD for Week 0 sessions: add, complete, count, watch |
| RingConstants | Config | `phoenix_app/lib/core/ring/ring_constants.dart` | BLE UUIDs, command bytes, capability flags, real-time types for Colmi R10 |
| RingProtocol | Core | `phoenix_app/lib/core/ring/ring_protocol.dart` | Packet encode/decode, checksum, BCD, parsers (battery, HR log, steps, real-time) |
| RingService | Core | `phoenix_app/lib/core/ring/ring_service.dart` | BLE scan, connect, pair (set time + caps), reconnect, command dispatch via universal_ble |
| RingDeviceDao | DAO | `phoenix_app/lib/core/database/daos/ring_device_dao.dart` | CRUD for paired ring device: save, watch, update battery/sync/capabilities, unpair |
| RingSettingsScreen | Screen | `phoenix_app/lib/features/settings/ring_settings_screen.dart` | Scan, pair, status card (battery/firmware/capabilities), find device, unpair, sync data, HR log settings |
| RingDataScreen | Screen | `phoenix_app/lib/features/settings/ring_data_screen.dart` | Ring data visualization: HR bar chart, steps chart, real-time HR streaming |
| RingLockManager | Core | `phoenix_app/lib/core/ring/ring_lock_manager.dart` | Mutex for real-time BLE operations — only one consumer at a time |
| SignalProcessor | Core | `phoenix_app/lib/core/ring/signal_processor.dart` | PPG signal pipeline: validation, SQI, outlier detection, smoothing, IBI→HR/RMSSD/SI |
| SleepParser | Core | `phoenix_app/lib/core/ring/sleep_parser.dart` | Stateful multi-packet sleep data parser (cmd 0x44), SleepSession/SleepPeriod/SleepStage |
| SleepSummary | Model | `phoenix_app/lib/core/ring/sleep_notifier.dart` | Sleep summary computation (quality label, staging durations, notification formatting) |
| RingSyncCoordinator | Core | `phoenix_app/lib/core/ring/ring_sync_coordinator.dart` | Auto-sync on app open: sleep→HRV→HR log→steps→battery, 15-min cooldown |
| MorningHrvCheck | Core | `phoenix_app/lib/core/ring/morning_hrv_check.dart` | Auto + manual 60s morning HRV measurement via ring |
| WorkoutBioTracker | Core | `phoenix_app/lib/core/ring/workout_bio_tracker.dart` | Multi-parameter real-time during workouts: HR/SpO2/HRV/SI cycling |
| RingDataDao | DAO | `phoenix_app/lib/core/database/daos/ring_data_dao.dart` | CRUD for ring_hr_samples, ring_sleep_stages, ring_steps |
| SleepHypnogram | Widget | `phoenix_app/lib/features/conditioning/widgets/sleep_hypnogram.dart` | fl_chart scatter-based sleep stage timeline |
| HrvMorningCard | Widget | `phoenix_app/lib/features/today/widgets/hrv_morning_card.dart` | Today screen card for manual HRV measurement with countdown + result |
| BioOverlay | Widget | `phoenix_app/lib/features/workout/widgets/bio_overlay.dart` | Compact live HR/SpO2/HRV/SI overlay for workout/cardio/cold screens |
| PhoenixHomeWidget | Core | `phoenix_app/lib/features/widgets/phoenix_home_widget.dart` | Home screen widget data update logic via home_widget package |
| PhoenixWidgetSmall | Android | `phoenix_app/android/.../PhoenixWidgetProvider.kt` | Android 2×2 home widget: protocol progress, steps, next step |
| PhoenixWidgetLarge | Android | `phoenix_app/android/.../PhoenixWidgetProvider.kt` | Android 4×4 home widget: full protocol, ring data, sleep, HRV |
| PhoenixWidgets | iOS | `phoenix_app/ios/PhoenixWidget/PhoenixWidget.swift` | iOS WidgetKit: small + large home screen widgets |

---

## Key Functions

| Function | Location | Lines | What it does |
|----------|----------|-------|--------------|
| TemplateChat.detect | `core/llm/template_chat.dart` | — | Classify user message into ChatIntent (training/fasting/weight/conditioning/biomarkers/motivation/general) |
| TemplateChat.respond | `core/llm/template_chat.dart` | — | Generate contextual response by querying DAOs based on detected intent |
| ExerciseDetailSheet.show | `features/exercise/exercise_detail_sheet.dart` | — | Static method to open exercise detail bottom sheet |
| MuscleBadge.parse | `features/exercise/widgets/muscle_badge.dart` | — | Parse comma-separated muscle string into list |
| NumberedSteps.parseSteps | `features/exercise/widgets/numbered_steps.dart` | — | Split executionCues on ". " into numbered step list |
| ExerciseHero.categoryColor | `features/exercise/widgets/exercise_hero.dart` | — | Category → color mapping for placeholders |
| DurationScoreCalculator.calculate | `core/models/duration_score.dart` | — | Phase 1/2 scoring: green/yellow/red via moving avg ± SD |
| RestTimes.betweenSets | `core/models/rest_times.dart` | — | Adaptive rest by exercise type × Phoenix level |
| LlmEngine.generate | `core/llm/llm_engine.dart` | — | Prompt render → runtime inference → result |
| LlmEngine.generateStream | `core/llm/llm_engine.dart` | — | Streaming token generation (real FFI stream or simulated for template) |
| LlmEngine.initBestRuntime | `core/llm/llm_engine.dart` | — | Auto-select runtime: if model exists + ≥3 tok/s → BitNet, else template fallback |
| ModelManager.download | `core/llm/model_manager.dart` | — | Download model with dio resume, Range headers, progress callbacks |
| ModelManager.verifyChecksum | `core/llm/model_manager.dart` | — | SHA256 file verification in isolate |
| ModelManager.deleteModel | `core/llm/model_manager.dart` | — | Delete model + partial download files |
| AudioEngine.startMetronome | `core/audio/audio_engine.dart` | — | Eccentric/pause/concentric phase beeps |
| NotificationService.scheduleFastingMilestones | `core/notifications/notification_service.dart` | — | 12h-72h zoned notifications |
| NotificationService.showNow | `core/notifications/notification_service.dart` | — | Show immediate notification (for background tasks) |
| NotificationScheduler.scheduleWorkoutReminder | `core/notifications/notification_scheduler.dart` | — | Next occurrence of HH:mm workout reminder |
| NotificationScheduler.scheduleConditioningReminderIfNeeded | `core/notifications/notification_scheduler.dart` | — | Evening conditioning reminder if no session today |
| ProgressionDao.checkProgressionCriteria | `core/database/daos/progression_dao.dart` | — | 2 consecutive sessions all-sets-max-reps RPE<=8 → nextExerciseId |
| ProgressionDao.recordAdvancement | `core/database/daos/progression_dao.dart` | — | Insert progression_history row |
| WorkoutGenerator.generateForDay | `core/models/workout_generator.dart` | — | Weekday + tier + equipment → WorkoutPlan |
| ExerciseDao.getForWorkout | `core/database/daos/exercise_dao.dart` | — | Best compound for category/level/equipment |
| ExerciseDao.getByIds | `core/database/daos/exercise_dao.dart` | — | Batch fetch exercises by ID set (single query) |
| ExerciseDao.getProgressionChain | `core/database/daos/exercise_dao.dart` | — | Full ordered exercise list for progression UI |
| PhenoAgeCalculator.calculate | `core/models/phenoage_calculator.dart` | — | 9 biomarkers + chronological age → PhenoAge (Levine 2018 Gompertz regression) |
| BiomarkerAlerts.check | `core/models/biomarker_alerts.dart` | — | Current + previous panel + sex → list of protocol-based alerts |
| ColdProgression.weekStats | `core/models/cold_progression.dart` | — | Sessions this week → ColdWeekStats (dose, sessions, progress) |
| ColdProgression.hoursSinceStrength | `core/models/cold_progression.dart` | — | Last strength end time → hours remaining for safe cold exposure |
| SleepScore.regularity | `core/models/sleep_score.dart` | — | Sleep entries → regularity level (high/medium/low via std dev) |
| SleepScore.averageDuration | `core/models/sleep_score.dart` | — | Sleep entries → average duration |
| BreathingState.tick | `core/models/breathing_controller.dart` | — | Advance breathing state by 1s, cycle through phases |
| WorkoutDao.lastStrengthEndTime | `core/database/daos/workout_dao.dart` | — | Most recent strength workout end time (for cold alert) |
| ConditioningDao.currentStreak | `core/database/daos/conditioning_dao.dart` | — | Consecutive days with session for given type |
| ConditioningDao.getTodaySessionCount | `core/database/daos/conditioning_dao.dart` | — | Count conditioning sessions today (any type) |
| WorkoutDao.getSession | `core/database/daos/workout_dao.dart` | — | Get workout session by ID |
| WorkoutDao.getSessionsInRange | `core/database/daos/workout_dao.dart` | — | Workout sessions in date range |
| WorkoutDao.getTodaySessions | `core/database/daos/workout_dao.dart` | — | Today's completed workout sessions |
| WorkoutDao.currentStreak | `core/database/daos/workout_dao.dart` | — | Consecutive days with completed workout |
| FastingDao.getSessionsInRange | `core/database/daos/fasting_dao.dart` | — | Fasting sessions in date range |
| FastingDao.getLastCompleted | `core/database/daos/fasting_dao.dart` | — | Most recent completed fast |
| ActivityRingsData.compute | `core/models/activity_rings_data.dart` | — | Compute progress for 3 dashboard rings |
| OneBigThing.compute | `core/models/activity_rings_data.dart` | — | Priority-based suggestion (alerts→training→fasting→conditioning→positive) |
| DashboardStats.compute | `core/models/activity_rings_data.dart` | — | PhenoAge, weight, streak, sleep avg from DB |
| ReportGenerator.generatePostWorkout | `core/models/report_generator.dart` | — | Template report for a workout session (exercises, RPE, score, comparison) |
| ReportGenerator.generateWeekly | `core/models/report_generator.dart` | — | Weekly summary (training/fasting/conditioning/weight/strengths) |
| ReportGenerator.generateFasting | `core/models/report_generator.dart` | — | Post-fasting report (duration, tolerance, level progression) |
| CoachPrompts.interSetCue | `core/models/coach_prompts.dart` | — | RPE + exercise category → motivational cue during rest phase |
| CoachPrompts.protocolNudge | `core/models/coach_prompts.dart` | — | Protocol completion state → nudge for next incomplete item |
| MealPlanGenerator.generateForDay | `core/models/meal_plan_generator.dart` | — | Weight + dayType → MealPlan (3 meals, scaled ingredients, protein cycling) |
| MealPlanGenerator.dayTypeForWeekday | `core/models/meal_plan_generator.dart` | — | Weekday → training/normal/autophagy day type |
| MedicalDisclaimerDialog.showIfNeeded | `shared/widgets/medical_disclaimer_dialog.dart` | — | Check disclaimer validity (90d), show modal if expired |
| FoodDao.getByTier | `core/database/daos/food_dao.dart` | — | Foods filtered by longevity tier (1-4) |
| FoodDao.search | `core/database/daos/food_dao.dart` | — | Case-insensitive food name search |
| MealTemplateDao.getByDayType | `core/database/daos/meal_template_dao.dart` | — | 3 meals for a given day type |
| AssessmentScoring.scorePushups | `core/models/assessment_scoring.dart` | — | ACSM norms push-up scoring by sex/age |
| AssessmentScoring.scorePlank | `core/models/assessment_scoring.dart` | — | McGill 2015 plank hold scoring |
| AssessmentScoring.scoreCooper | `core/models/assessment_scoring.dart` | — | Cooper 1968 VO2max estimation from 12-min distance |
| AssessmentScoring.generateScoresJson | `core/models/assessment_scoring.dart` | — | Generate JSON of all test scores for DB storage |
| AssessmentScoring.compare | `core/models/assessment_scoring.dart` | — | Compare two assessments, return deltas per test |
| AssessmentDao.isAssessmentDue | `core/database/daos/assessment_dao.dart` | — | True if >= 28 days since last assessment |
| NotificationScheduler.scheduleAssessmentReminderIfNeeded | `core/notifications/notification_scheduler.dart` | — | Schedule assessment reminder 28 days after last |
| ResearchFetcher.fetchRecent | `core/research/research_fetcher.dart` | — | Fetch from PubMed + Europe PMC, rotate keywords, max 20/session, dedup |
| ResearchEvaluator.evaluateNew | `core/research/research_evaluator.dart` | — | Evaluate unevaluated papers (LLM or keyword heuristic), set impact + summary |
| ProtocolUpdater.generateMonthlyReport | `core/research/protocol_updater.dart` | — | Monthly summary: papers by area, high impact, pending updates |
| ProtocolUpdater.approveUpdate | `core/research/protocol_updater.dart` | — | Mark update proposal as approved |
| ProtocolUpdater.rejectUpdate | `core/research/protocol_updater.dart` | — | Mark update proposal as rejected |
| ResearchFeedDao.existsByDoi | `core/database/daos/research_feed_dao.dart` | — | Dedup check by DOI |
| TemplateChat.postSetFeedback | `core/llm/template_chat.dart` | — | Template-based post-set coach feedback (fallback when LLM unavailable) |
| TemplateChat.parseCoachData | `core/llm/template_chat.dart` | — | Parse [DATI: reps=X, rpe=Y, dolore=Z] from LLM response |
| TemplateChat.stripCoachData | `core/llm/template_chat.dart` | — | Remove metadata line from coach response for display |
| CoachPrompts.postSetQuestion | `core/models/coach_prompts.dart` | — | AI coach opening question after a set (varies by set number) |
| CoachPrompts.postSetTemplateFeedback | `core/models/coach_prompts.dart` | — | Template coach encouragement based on reps/RPE (no LLM) |
| _runNightlyResearch | `core/background/background_tasks.dart` | — | Background task: fetch + evaluate + notify if high-impact found |
| TemplateChat.getExcludedExerciseIds | `core/llm/template_chat.dart` | — | Body zones → exercise IDs to exclude (name pattern matching) |
| TemplateChat.parseAssessmentData | `core/llm/template_chat.dart` | — | Parse [ASSESSMENT: JSON] from LLM physical assessment response |
| TemplateChat.stripAssessmentData | `core/llm/template_chat.dart` | — | Remove [ASSESSMENT:] metadata from response for display |
| SettingsNotifier.setPhysicalLimitations | `core/models/settings_notifier.dart` | — | Save limitations JSON + excluded IDs + assessment date |
| SettingsNotifier.setSleepEnvironmentJson | `core/models/settings_notifier.dart` | — | Save sleep environment config JSON |
| SleepCoach.eveningTips | `core/models/sleep_environment.dart` | — | Generate priority-sorted coaching tips from env config + sleep history |
| SleepEnvironment.blueLightCutoff | `core/models/sleep_environment.dart` | — | bedtime - N hours → cutoff TimeOfDay |
| SleepEnvironment.caffeineCutoff | `core/models/sleep_environment.dart` | — | bedtime - N hours → cutoff TimeOfDay |
| CoachPrompts.sleepCaffeineMorning | `core/models/coach_prompts.dart` | — | Morning caffeine cutoff message |
| CoachPrompts.sleepEveningCoaching | `core/models/coach_prompts.dart` | — | Evening pre-bedtime coaching message |
| NotificationScheduler.scheduleSleepEnvironmentReminders | `core/notifications/notification_scheduler.dart` | — | Schedule caffeine/blue light/temperature reminders based on SleepEnvironment |
| SupplementEngine.evaluate | `core/models/supplement_engine.dart` | — | Biomarkers + age + sex + trainingLoad → sorted trilingual SupplementRecommendations (Western/Russian/Chinese) |
| SupplementEngine.missingBiomarkers | `core/models/supplement_engine.dart` | — | Identify which supplement-relevant biomarkers haven't been entered |
| PeriodizationEngine.getParamsForDay | `core/models/periodization_engine.dart` | — | Tier + MesocycleState + weekday → WorkoutParams (sets, reps, rest, RPE, load%, stimulus) |
| PeriodizationEngine.advanceWeek | `core/models/periodization_engine.dart` | — | Advance mesocycle state to next week/block/cycle |
| PeriodizationEngine.shouldDeload | `core/models/periodization_engine.dart` | — | Scheduled deload, RPE ≥ 9, or cortisol biomarker alert → deload flag |
| PeriodizationEngine.currentPhaseDescription | `core/models/periodization_engine.dart` | — | Italian description of current periodization phase |
| ExerciseRotator.selectForMesocycle | `core/models/exercise_rotator.dart` | — | Slot-based exercise selection with ≥70% novelty, locked/excluded IDs, deterministic shuffle |
| ExerciseRotator.slotsForStrengthDay | `core/models/exercise_rotator.dart` | — | Generate RotationSlots for a strength day by category/compound/accessory counts |
| Week0Generator.generatePlan | `core/models/week0_generator.dart` | — | Static: 6 familiarization sessions (lower/upper/core/integration/full body) |
| CardioProtocols.tabata | `core/models/cardio_protocols.dart` | — | Tabata 1996 HIIT protocol: 8×20s work + 10s rest + Zone 2 cooldown |
| CardioProtocols.norwegian | `core/models/cardio_protocols.dart` | — | Wisløff 2007 Norwegian 4×4: 4×4min at 90-95% HRmax + 3min recovery |
| CardioProtocols.zone2Only | `core/models/cardio_protocols.dart` | — | Zone 2 steady state: 30-45min at 60-70% HRmax |
| HrvEngine.computeBaseline | `core/models/hrv_engine.dart` | — | 14 readings → LnRMSSD baseline with SWC bands |
| HrvEngine.assessRecovery | `core/models/hrv_engine.dart` | — | Today's reading vs baseline → RecoveryStatus (ready/caution/compromised) |
| WorkoutDao.markWarmupCompleted | `core/database/daos/workout_dao.dart` | — | Mark warmup phase as completed for a session |
| WorkoutDao.markStabilityCompleted | `core/database/daos/workout_dao.dart` | — | Mark stability phase as completed for a session |
| WorkoutDao.markCooldownCompleted | `core/database/daos/workout_dao.dart` | — | Mark cooldown phase as completed for a session |
| MesocycleDao.getCurrentMesocycle | `core/database/daos/mesocycle_dao.dart` | — | Latest active (not completed) mesocycle state |
| HrvDao.getReadingsForBaseline | `core/database/daos/hrv_dao.dart` | — | Last 14 readings for baseline calculation |
| ExerciseHero.assetPathFor | `features/exercise/widgets/exercise_hero.dart` | — | Exercise ID → asset path (assets/exercises/{id}.webp), fallback to category placeholder |
| RingProtocol.makePacket | `core/ring/ring_protocol.dart` | — | Build 16-byte command packet with checksum |
| RingProtocol.parseBattery | `core/ring/ring_protocol.dart` | — | Parse battery level + charging status from response |
| RingProtocol.parseRealTimeReading | `core/ring/ring_protocol.dart` | — | Parse real-time HR/SpO2/HRV reading from 0x69 response |
| HeartRateLogParser.parse | `core/ring/ring_protocol.dart` | — | Stateful multi-packet HR log parser (288 slots/day × 5 min) |
| SportDetailParser.parse | `core/ring/ring_protocol.dart` | — | Stateful multi-packet step data parser (15-min intervals, BCD dates) |
| RingCapabilities.fromPacket | `core/ring/ring_constants.dart` | — | Parse capability flags from set_time response (HRV, SpO2, temp, etc.) |
| RingService.connect | `core/ring/ring_service.dart` | — | BLE connect → subscribe notifications → set time → read capabilities → ready |
| RingService.startRealTimeHr | `core/ring/ring_service.dart` | — | Start real-time HR streaming (0x69) |
| RingService.readHeartRateLog | `core/ring/ring_service.dart` | — | Read full day HR log (multi-packet assembly with timeout) |
| RingService.readSteps | `core/ring/ring_service.dart` | — | Read step data for N days ago (multi-packet) |
| RingService.readSleep | `core/ring/ring_service.dart` | — | Read sleep data for last night (multi-packet, cmd 0x44) |
| RingService.probeRawPpgSupport | `core/ring/ring_service.dart` | — | Test if R10 supports raw PPG streaming (cmd 0x68) |
| RingService.startRawPpg | `core/ring/ring_service.dart` | — | Start raw PPG sensor streaming |
| SignalProcessor.assessSignalQuality | `core/ring/signal_processor.dart` | — | SQI from reading window (stuck, jumps, range, CV) |
| SignalProcessor.computeRmssd | `core/ring/signal_processor.dart` | — | RMSSD from inter-beat intervals |
| SignalProcessor.computeStressIndex | `core/ring/signal_processor.dart` | — | Bayevsky SI from IBI (AMo/2*Mo*MxDMn) |
| SignalProcessor.filterHrLog | `core/ring/signal_processor.dart` | — | Remove invalid + outliers from HR log |
| SleepSummary.fromSession | `core/ring/sleep_notifier.dart` | — | Compute quality label + durations from SleepSession |
| RingSyncCoordinator.syncIfNeeded | `core/ring/ring_sync_coordinator.dart` | — | Full sync if ring connected + 15min cooldown elapsed |
| MorningHrvCheck.autoAttempt | `core/ring/morning_hrv_check.dart` | — | Silent 60s HRV after sleep sync (6-12h window) |
| MorningHrvCheck.manualMeasure | `core/ring/morning_hrv_check.dart` | — | UI-triggered 60s HRV countdown, returns RMSSD |
| WorkoutBioTracker.start | `core/ring/workout_bio_tracker.dart` | — | Acquire lock + start HR streaming for workout |
| WorkoutBioTracker.onSetEnd | `core/ring/workout_bio_tracker.dart` | — | Capture SetBioStats (avgHR, maxHR, recovery, SpO2, RMSSD) |
| CoachPrompts.bioCue | `core/models/coach_prompts.dart` | — | Bio-based coaching cue (HR zone, SpO2, SI, recovery, temp) |
| PhoenixHomeWidget.update | `features/widgets/phoenix_home_widget.dart` | — | Save protocol + ring data to home_widget SharedPreferences |
| RingDataDao.upsertHrSample | `core/database/daos/ring_data_dao.dart` | — | Dedup HR sample on (timestamp, source) |
| RingDataDao.replaceSleepStages | `core/database/daos/ring_data_dao.dart` | — | Replace all sleep stages for a night |
| RingDataDao.hasLastNightSleep | `core/database/daos/ring_data_dao.dart` | — | Check if ring sleep data exists for last night |
| RingDataDao.getTodaySteps | `core/database/daos/ring_data_dao.dart` | — | Sum steps for today |

---

## API Endpoints

| Method | Route | Handler | Auth required |
|--------|-------|---------|---------------|
| | | | |

---

## Database

### Tables
| Table | Key columns | Used by |
|-------|-------------|---------|
| exercises | id, name, category, phoenix_level, progression_next/prev_id | WorkoutEngine, Progressions |
| workout_sessions | id, started_at, ended_at, type, duration_score, llm_summary | WorkoutEngine, Coach |
| workout_sets | id, session_id, exercise_id, reps_completed, rpe, tempo | WorkoutEngine |
| fasting_sessions | id, started_at, target_hours, level, glucose_json, hrv_json, tolerance_score, energy_score, water_count, refeeding_notes | FastingTracker, Coach, Levels |
| meal_logs | id, date, meal_time, description, protein_estimate, feeling, notes | NutritionTab |
| biomarkers | id, date, type, values_json | BiomarkerTracker |
| conditioning_sessions | id, date, type, duration_seconds, temperature | ConditioningTracker |
| llm_reports | id, type, prompt_template, context_data_json, output_text | Coach |
| progression_history | id, exercise_id, from_level, to_level, criteria_met_json | Progressions |
| user_settings | id, settings_json (includes disclaimerAcceptedAt) | App-wide |
| food_items | id, name, category, macros, longevity_tier, active_compounds JSON | FoodDao, MealPlanGenerator |
| meal_templates | id, day_type, meal_number, time_slot, ingredients JSON, protein_estimate_g, calories_estimate | MealTemplateDao, MealPlanGenerator |
| assessments | id, date, pushup_max_reps, wall_sit_seconds, plank_hold_seconds, sit_and_reach_cm, cooper_distance_m, weight_kg, waist/chest/arm_cm, scores_json | AssessmentDao, AssessmentScreen |
| research_feed | id, found_date, source, language, title, abstract_text, doi, url, area, key_summary, impact, user_read, proposed_update, update_proposal, update_status | ResearchFeedDao, ResearchFetcher, Coach |
| cardio_sessions | id, date, protocol, total_duration_seconds, rounds_completed, avg_hr, max_hr, avg_rpe, modality, notes | CardioDao, CardioSessionScreen |
| mesocycle_states | id, tier, mesocycle_number, week_in_mesocycle, current_block, started_at, completed_at | MesocycleDao, PeriodizationEngine |
| mesocycle_exercises | id, mesocycle_number, slot_category, slot_type, slot_index, exercise_id, locked | MesocycleDao, ExerciseRotator |
| hrv_readings | id, timestamp, rmssd, ln_rmssd, stress_index, source, context | HrvDao, HrvEngine |
| week0_sessions | id, session_number, focus, completed_at, avg_rpe, passed, notes | Week0Dao, Week0Generator |
| ring_devices | id, mac_address, name, firmware_version, hardware_version, capabilities_json, last_sync, battery_level, paired_at | RingDeviceDao, RingService |
| ring_hr_samples | id, timestamp, hr, source, quality | RingDataDao, SignalProcessor |
| ring_sleep_stages | id, night_date, stage, start_time, end_time, hr_avg, temp_avg | RingDataDao, SleepDataParser |
| ring_steps | id, timestamp, steps, calories, distance_m | RingDataDao, RingSyncCoordinator |

### Modified tables (v11)
| Table | New columns | Used by |
|-------|------------|---------|
| workout_sets | avg_hr, max_hr, spo2, rmssd, stress_index, hr_recovery_bpm, skin_temp | WorkoutBioTracker |
| workout_sessions | avg_hr, max_hr, avg_spo2, avg_rmssd, bio_stats_json | WorkoutBioTracker, SessionBioStats |

### Important queries
| Name | Location | What it does |
|------|----------|--------------|
| watchActiveFast | `daos/fasting_dao.dart` | Stream of active (non-ended) fasting session |
| watchRecentSessions | `daos/workout_dao.dart` | Stream of last N workout sessions |
| watchByType (biomarker) | `daos/biomarker_dao.dart` | Stream of biomarkers filtered by type |
| watchByType (conditioning) | `daos/conditioning_dao.dart` | Stream of conditioning sessions by type |
| watchMealsForDay | `daos/meal_log_dao.dart` | Stream of meals for a given day |
| canAdvanceToLevel | `daos/fasting_dao.dart` | Check if fasting level advancement criteria met |
| getLevelStats | `daos/fasting_dao.dart` | Total + good-tolerance count for a fasting level |

---

## Data Flows

*Document important data flows here.*

---

## External Dependencies

| Package | Version | Used for |
|---------|---------|----------|
| flutter_riverpod | ^2.6.1 | State management |
| drift | ^2.23.1 | SQLite database (type-safe) |
| just_audio | ^0.9.42 | Metronome, beeps |
| flutter_local_notifications | ^18.0.1 | Fasting milestones, reminders |
| workmanager | ^0.5.2 | Background tasks |
| fl_chart | ^0.70.2 | Biomarker charts |
| google_fonts | ^6.2.1 | Typography (Inter) |
| timezone | ^0.10.1 | Zoned notification scheduling |
| ffi | ^2.1.3 | bitnet.cpp native bridge |
| flutter_tts | ^4.2.0 | TTS coach motivazionale |
| dio | ^5.4.0 | Model download with resume support |
| universal_ble | ^1.2.0 | BLE communication for Colmi R10 smart ring (BSD-3, all platforms) |
| crypto | ^3.0.3 | SHA256 checksum verification |
| tdesign_flutter | local (^0.2.7) | UI component library: TDButton, TDNavBar, TDBottomTabBar, TDLoading, TDToast, TDSwitch, TDTag, TDRate, TDProgress, TDSwipeCell |
| home_widget | ^0.7.0 | Android/iOS home screen widgets (SharedPreferences bridge) |

---

## Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| | | |

---

## Notes

### Reference Documents

| Document | Location | Content |
|----------|----------|---------|
| Protocol 1 (original) | `references/protocol-1.md` | Protocollo originale utente (contiene citazioni non verificate) |
| Protocol 1 (verified) | `references/protocol-1-verified.md` | Fact-check con 30 fonti DOI, correzioni, studi 2023-2026 |
| Training analysis | `references/training-analysis-verified.md` | Analisi critica xlsx + 26 studi occidentali |
| Trilingual research | `references/training-research-trilingual.md` | 22 articoli russi + 20 cinesi + monografie Verkhoshansky |
| **Phoenix Protocol** | `references/phoenix-protocol.md` | **Protocollo completo v2.0+** — 12 sezioni (0-7 + bibliografia), 122+ fonti trilingue. Include: food database verificato (sez. 4.4), cue esecuzione corpo libero (sez. 2.7) |
| Exercise execution | `references/esecuzione-esercizi.md` | Principi esecuzione (parzialmente verificati) |
| Month A/B/C xlsx | `references/MONTH A.xlsx` etc. | Programmi originali utente (12-21 reps, endurance focus) |
| Calisthenic xlsx | `references/CALISTHENIC.xlsx` | 3 sheet (Beg/Int/Adv), 6gg corpo libero. No split, no periodizzazione. Reps Advanced irrealistiche. Cue esecuzione utili |
| Dietary Regime xlsx | `references/DIETARY REGIME.xlsx` | 4 sheet (Diet/Supplements/DB/Food). 7 pasti 07-22, ~2950kcal, 15 integratori. Incompatibile con TRE. Food DB recuperabile |
| Russian app design research | `references/russian-fitness-app-design-research.md` | 10 app analizzate (Welltory, FitStars, GOGYM, GymUp, Kenko, Meditopia, GoFasting, FitnessKit, etc.) + pattern di design cross-culturali + raccomandazioni per Phoenix |

### App Specs (da sviluppare)

| Spec | Location | Status |
|------|----------|--------|
| Biomarker features | `.claude/docs/specs/app-biomarker-features.md` | Completata (Phase 4) |
| Protocol spec | `.claude/docs/specs/phoenix-protocol.md` | Completata → protocollo scritto |


---

## How I Use This

1. **Before claiming something exists:** `grep "name" .claude/docs/registry.md`
2. **After discovering something:** Add it here immediately
3. **Before implementing:** Check what's already here
4. **After implementing:** Update with new components/functions

**If I'm about to write code that calls a function not listed here, I STOP and verify it exists first.**
