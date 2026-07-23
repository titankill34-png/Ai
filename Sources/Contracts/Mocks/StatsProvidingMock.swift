import Foundation

/// Fixed-value `StatsProviding` for previews, tests, and Tony's UI work.
final class StatsProvidingMock: StatsProviding {
    var averageInterval: TimeInterval?
    private let saved: Decimal
    private let calendar: Calendar

    init(averageInterval: TimeInterval? = 96 * 60, moneySaved: Decimal = 42.50, calendar: Calendar = .current) {
        self.averageInterval = averageInterval
        self.saved = moneySaved
        self.calendar = calendar
    }

    func dailyCounts(range: ClosedRange<Date>) -> [DayCount] {
        let startDay = calendar.startOfDay(for: range.lowerBound)
        let endDay = calendar.startOfDay(for: range.upperBound)
        var result: [DayCount] = []
        var day = startDay
        var i = 0
        while day <= endDay {
            // Gentle downward-trending sample pattern.
            result.append(DayCount(day: day, count: max(0, 8 - (i % 9))))
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
            i += 1
        }
        return result
    }

    func moneySaved(baselinePerDay: Double, unitCost: Decimal) -> Decimal { saved }
}
