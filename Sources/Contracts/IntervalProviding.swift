import Foundation

/// Read model for the craving-interval feature: how long since the last log, the
/// current adaptive target, and progress toward it. UI binds to this; the real
/// implementation lives in `Sources/Core`, a mock in `Sources/Contracts/Mocks`.
protocol IntervalProviding {
    /// The current target interval the user is trying to reach between logs.
    var targetInterval: TimeInterval { get }
    /// Time elapsed since the most recent log, or nil if there are no logs yet.
    func timeSinceLast(now: Date) -> TimeInterval?
    /// When the next target is reached: last log + `targetInterval` (nil if no logs).
    func nextTargetDate(now: Date) -> Date?
    /// Progress toward the current target in `[0, 1]`.
    func progress(now: Date) -> Double
}

extension IntervalProviding {
    /// True once the user has reached (or passed) the current target since the last log.
    func isOnTrack(now: Date) -> Bool {
        guard let elapsed = timeSinceLast(now: now) else { return false }
        return elapsed >= targetInterval
    }
}
