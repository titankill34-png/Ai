import SwiftUI

/// A glassmorphic "Today" summary card: three rows derived from `StatsProviding`
/// — logs today, average interval between logs, and money saved.
///
/// A reusable component (not a screen): inject any `StatsProviding` — the mock in
/// previews, the real `StatsEngine` in the app.
struct TodayStatsCard: View {
    let stats: StatsProviding
    var now: Date = .now

    // Baseline economics until a Settings screen supplies them (future task).
    private let baselinePerDay = 10.0
    private let unitCost: Decimal = 0.60

    var body: some View {
        VStack(spacing: 16) {
            header
            statRow(icon: "flame.fill", title: "Logs today", value: countTodayText)
            divider
            statRow(icon: "clock.fill", title: "Avg interval", value: averageIntervalText)
            divider
            statRow(icon: "banknote.fill", title: "Saved", value: moneySavedText)
        }
        .glassCard(padding: 20)
    }

    private var header: some View {
        HStack {
            Text("Today")
                .font(.nicoraTitle)
                .foregroundStyle(NicoraColor.textPrimary)
            Spacer()
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(NicoraColor.glassStroke)
            .frame(height: 1)
    }

    private func statRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(NicoraColor.textSecondary)
                .frame(width: 24)
            Text(title)
                .font(.nicoraBody)
                .foregroundStyle(NicoraColor.textSecondary)
            Spacer()
            Text(value)
                .font(.nicoraHeadline)
                .foregroundStyle(NicoraColor.textPrimary)
                .contentTransition(.numericText())
        }
    }

    // MARK: Derived values

    private var countTodayText: String {
        "\(stats.dailyCounts(lastDays: 1, now: now).last?.count ?? 0)"
    }

    private var averageIntervalText: String {
        guard let avg = stats.averageInterval else { return "—" }
        return Self.intervalFormatter.string(from: avg) ?? "—"
    }

    private var moneySavedText: String {
        let saved = stats.moneySaved(baselinePerDay: baselinePerDay, unitCost: unitCost)
        return Self.currencyFormatter.string(from: saved as NSDecimalNumber) ?? "—"
    }

    private static let intervalFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }()

    private static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()
}

#Preview {
    ZStack {
        GradientBackground()
        TodayStatsCard(stats: StatsProvidingMock())
            .padding()
    }
}
