import WidgetKit
import SwiftUI

struct PhoenixEntry: TimelineEntry {
    let date: Date
    let protocolDone: Int
    let protocolTotal: Int
    let steps: Int
    let levelNumber: Int
    let levelName: String
    let nextStep: String
    let sleepDone: Bool
    let trainingDone: Bool
    let fastingDone: Bool
    let coldDone: Bool
    let meditationDone: Bool
    let hrvMs: Double
    let recovery: String
    let sleepSummary: String
}

struct PhoenixProvider: TimelineProvider {
    let appGroupId = "group.phoenix.widget"

    func placeholder(in context: Context) -> PhoenixEntry {
        PhoenixEntry(
            date: Date(),
            protocolDone: 0, protocolTotal: 6,
            steps: 0, levelNumber: 1, levelName: "",
            nextStep: "", sleepDone: false, trainingDone: false,
            fastingDone: false, coldDone: false, meditationDone: false,
            hrvMs: 0, recovery: "", sleepSummary: ""
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PhoenixEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PhoenixEntry>) -> Void) {
        let entry = readEntry()
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func readEntry() -> PhoenixEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        return PhoenixEntry(
            date: Date(),
            protocolDone: defaults?.integer(forKey: "phoenix_protocol_done") ?? 0,
            protocolTotal: defaults?.integer(forKey: "phoenix_protocol_total") ?? 6,
            steps: defaults?.integer(forKey: "phoenix_steps") ?? 0,
            levelNumber: defaults?.integer(forKey: "phoenix_level_number") ?? 1,
            levelName: defaults?.string(forKey: "phoenix_level_name") ?? "",
            nextStep: defaults?.string(forKey: "phoenix_next_step") ?? "",
            sleepDone: defaults?.bool(forKey: "phoenix_sleep_done") ?? false,
            trainingDone: defaults?.bool(forKey: "phoenix_training_done") ?? false,
            fastingDone: defaults?.bool(forKey: "phoenix_fasting_done") ?? false,
            coldDone: defaults?.bool(forKey: "phoenix_cold_done") ?? false,
            meditationDone: defaults?.bool(forKey: "phoenix_meditation_done") ?? false,
            hrvMs: defaults?.double(forKey: "phoenix_hrv_ms") ?? 0,
            recovery: defaults?.string(forKey: "phoenix_recovery") ?? "",
            sleepSummary: defaults?.string(forKey: "phoenix_sleep_summary") ?? ""
        )
    }
}

struct PhoenixWidgetSmallView: View {
    let entry: PhoenixEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("PHOENIX")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
                Spacer()
                Text("LV \(entry.levelNumber)")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }

            Text("\(entry.protocolDone)/\(entry.protocolTotal)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.orange)

            if entry.steps > 0 {
                Text("\(entry.steps) passi")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }

            if !entry.nextStep.isEmpty {
                Text(entry.nextStep)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(8)
        .containerBackground(for: .widget) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
        }
    }
}

struct PhoenixWidgetLargeView: View {
    let entry: PhoenixEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header
            HStack {
                Text("PHOENIX")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.orange)
                Spacer()
                Text("LV \(entry.levelNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }

            Text("Protocollo: \(entry.protocolDone)/\(entry.protocolTotal)")
                .font(.system(size: 13))
                .foregroundColor(.orange)

            // Protocol items
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 2) {
                protocolItem("Sonno", done: entry.sleepDone)
                protocolItem("Training", done: entry.trainingDone)
                protocolItem("Digiuno", done: entry.fastingDone)
                protocolItem("Freddo", done: entry.coldDone)
                protocolItem("Meditazione", done: entry.meditationDone)
                protocolItem("Nutrizione", done: false)
            }

            // Ring data
            HStack {
                if entry.steps > 0 {
                    Text("\(entry.steps) passi")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                }
                if entry.hrvMs > 0 {
                    Text("HRV \(Int(entry.hrvMs))ms")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                }
                if !entry.recovery.isEmpty {
                    Text(entry.recovery)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            if !entry.sleepSummary.isEmpty {
                Text(entry.sleepSummary)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }

            if !entry.nextStep.isEmpty {
                Text(entry.nextStep)
                    .font(.system(size: 11))
                    .foregroundColor(.orange)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .containerBackground(for: .widget) {
            Color(red: 0.1, green: 0.1, blue: 0.1)
        }
    }

    func protocolItem(_ name: String, done: Bool) -> some View {
        Text("\(done ? "✓" : "○") \(name)")
            .font(.system(size: 10))
            .foregroundColor(done ? .green : .white.opacity(0.7))
    }
}

@main
struct PhoenixWidgets: WidgetBundle {
    var body: some Widget {
        PhoenixSmallWidget()
        PhoenixLargeWidget()
    }
}

struct PhoenixSmallWidget: Widget {
    let kind = "PhoenixSmallWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PhoenixProvider()) { entry in
            PhoenixWidgetSmallView(entry: entry)
        }
        .configurationDisplayName("Phoenix Compatto")
        .description("Protocollo e passi")
        .supportedFamilies([.systemSmall])
    }
}

struct PhoenixLargeWidget: Widget {
    let kind = "PhoenixLargeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PhoenixProvider()) { entry in
            PhoenixWidgetLargeView(entry: entry)
        }
        .configurationDisplayName("Phoenix Completo")
        .description("Protocollo, ring, prossimo step")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
