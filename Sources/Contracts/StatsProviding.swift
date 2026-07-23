import Foundation

/// Number of logs on a single calendar day.
struct DayCount: Identifiable, Equatable, Sendable {
    var id: Date { day }
    /// Start of the calendar day.
    let day: Date
    let count: Int

    init(day: Date, count: Int) {
        self.day = day
        self.count = count
    }
}

/// Derived statistics over the log history: per-day counts, average interval,
/// and money saved. Drives the stats card, bar chart, and donut ring (lane:tony).
protocol StatsProviding {
    /// Logs per calendar day across `range`, ascending, including zero-count days.
    func dailyCounts(range: ClosedRange<Date>) -> [DayCount]
    /// Mean interval between consecutive logs across all history (nil if < 2 logs).
    var averageInterval: TimeInterval? { get }
    /// Money saved vs. a baseline habit: `max(0, baselinePerDay × days − logs) × unitCost`.
    func moneySaved(baselinePerDay: Double, unitCost: Decimal) -> Decimal
}

extension StatsProviding {
    /// Convenience: daily counts for the last `days` days ending today.
    func dailyCounts(lastDays days: Int, now: Date = .now, calendar: Calendar = .current) -> [DayCount] {
        let end = now
        let start = calendar.date(byAdding: .day, value: -(max(days, 1) - 1), to: end) ?? end
        return dailyCounts(range: start...end)
    }
}
