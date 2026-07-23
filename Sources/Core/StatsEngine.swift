import Foundation

/// Pure statistics over a snapshot of log timestamps. No persistence, no UI.
final class StatsEngine: StatsProviding {
    /// Log timestamps, oldest first.
    private let timestamps: [Date]
    private let calendar: Calendar

    init(entries: [SmokeLogEntry], calendar: Calendar = .current) {
        self.timestamps = entries.map(\.timestamp).sorted()
        self.calendar = calendar
    }

    func dailyCounts(range: ClosedRange<Date>) -> [DayCount] {
        let startDay = calendar.startOfDay(for: range.lowerBound)
        let endDay = calendar.startOfDay(for: range.upperBound)

        var counts: [Date: Int] = [:]
        for ts in timestamps {
            let day = calendar.startOfDay(for: ts)
            if day >= startDay && day <= endDay {
                counts[day, default: 0] += 1
            }
        }

        var result: [DayCount] = []
        var day = startDay
        while day <= endDay {
            result.append(DayCount(day: day, count: counts[day] ?? 0))
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return result
    }

    var averageInterval: TimeInterval? {
        guard timestamps.count >= 2, let first = timestamps.first, let last = timestamps.last else {
            return nil
        }
        return last.timeIntervalSince(first) / Double(timestamps.count - 1)
    }

    func moneySaved(baselinePerDay: Double, unitCost: Decimal) -> Decimal {
        guard let first = timestamps.first, let last = timestamps.last else { return 0 }
        let spanDays = (calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: first),
            to: calendar.startOfDay(for: last)
        ).day ?? 0) + 1
        let days = max(1, spanDays)
        let expected = baselinePerDay * Double(days)
        let saved = max(0, expected - Double(timestamps.count))
        return Decimal(saved) * unitCost
    }
}
