import SwiftUI
import Charts

/// A Swift Charts bar chart of the last six months of logs, aggregated from
/// `StatsProviding.dailyCounts`. Reusable component; inject the mock in previews,
/// the real `StatsEngine` in the app.
struct SixMonthBarChart: View {
    let stats: StatsProviding
    var now: Date = .now
    var calendar: Calendar = .current

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 6 months")
                .font(.nicoraHeadline)
                .foregroundStyle(NicoraColor.textPrimary)

            Chart(monthlyBuckets) { bucket in
                BarMark(
                    x: .value("Month", bucket.month, unit: .month),
                    y: .value("Logs", bucket.count)
                )
                .foregroundStyle(NicoraColor.textPrimary.opacity(0.85))
                .cornerRadius(6)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { _ in
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                        .foregroundStyle(NicoraColor.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine().foregroundStyle(NicoraColor.glassStroke)
                    AxisValueLabel().foregroundStyle(NicoraColor.textSecondary)
                }
            }
            .frame(height: 220)
        }
        .glassCard(padding: 20)
    }

    /// Six monthly buckets ending with the current month, each summing the daily
    /// counts that fall within it. Empty months still render a zero-height slot.
    private var monthlyBuckets: [MonthBucket] {
        let startOfThisMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        guard let start = calendar.date(byAdding: .month, value: -5, to: startOfThisMonth) else {
            return []
        }

        var totals: [Date: Int] = [:]
        var months: [Date] = []
        for offset in 0..<6 {
            guard let month = calendar.date(byAdding: .month, value: offset, to: start) else { continue }
            months.append(month)
            totals[month] = 0
        }

        for day in stats.dailyCounts(range: start...now) {
            if let month = calendar.dateInterval(of: .month, for: day.day)?.start {
                totals[month, default: 0] += day.count
            }
        }

        return months.map { MonthBucket(month: $0, count: totals[$0] ?? 0) }
    }
}

/// One month's total for the chart.
private struct MonthBucket: Identifiable {
    let month: Date
    let count: Int
    var id: Date { month }
}

#Preview {
    ZStack {
        GradientBackground()
        SixMonthBarChart(stats: StatsProvidingMock())
            .padding()
    }
}
