import Foundation

/// Tuning for the adaptive interval goal.
struct IntervalConfig: Equatable {
    /// Starting goal between logs.
    var baseInterval: TimeInterval
    /// Hard ceiling the goal can grow to.
    var maxInterval: TimeInterval
    /// Multiplier applied each time the user complies (a gap ≥ the goal).
    var growthFactor: Double
    /// Multiplier applied each time the user misses (a gap < the goal).
    var shrinkFactor: Double

    static let `default` = IntervalConfig(
        baseInterval: 45 * 60,      // 45 minutes
        maxInterval: 8 * 60 * 60,   // 8 hours
        growthFactor: 1.10,
        shrinkFactor: 0.95
    )
}

/// Computes time-since-last-log and an **adaptive** target interval that lengthens
/// as the user complies (leaves longer gaps than the goal) and eases back — never
/// below `baseInterval` — when they don't. Pure and deterministic: it takes a
/// snapshot of log timestamps and never touches persistence or UI.
final class IntervalEngine: IntervalProviding {
    private let config: IntervalConfig
    /// Log timestamps, oldest first.
    private let timestamps: [Date]

    init(entries: [SmokeLogEntry], config: IntervalConfig = .default) {
        self.config = config
        self.timestamps = entries.map(\.timestamp).sorted()
    }

    /// Most recent log timestamp, if any.
    var lastLog: Date? { timestamps.last }

    /// The adaptive goal, derived by walking every consecutive gap in the history:
    /// grow on compliance, shrink toward the base on a miss.
    var targetInterval: TimeInterval {
        var target = config.baseInterval
        guard timestamps.count >= 2 else { return target }
        for i in 1..<timestamps.count {
            let gap = timestamps[i].timeIntervalSince(timestamps[i - 1])
            if gap >= target {
                target = min(target * config.growthFactor, config.maxInterval)
            } else {
                target = max(target * config.shrinkFactor, config.baseInterval)
            }
        }
        return target
    }

    func timeSinceLast(now: Date) -> TimeInterval? {
        guard let last = lastLog else { return nil }
        return now.timeIntervalSince(last)
    }

    func nextTargetDate(now: Date) -> Date? {
        guard let last = lastLog else { return nil }
        return last.addingTimeInterval(targetInterval)
    }

    func progress(now: Date) -> Double {
        guard let elapsed = timeSinceLast(now: now), targetInterval > 0 else { return 0 }
        return min(max(elapsed / targetInterval, 0), 1)
    }
}
