import Foundation

/// Fixed-value `IntervalProviding` for previews, tests, and Tony's UI work.
final class IntervalProvidingMock: IntervalProviding {
    var targetInterval: TimeInterval
    private let elapsed: TimeInterval?
    private let last: Date?

    init(
        targetInterval: TimeInterval = 90 * 60,
        elapsed: TimeInterval? = 42 * 60,
        last: Date? = Date().addingTimeInterval(-42 * 60)
    ) {
        self.targetInterval = targetInterval
        self.elapsed = elapsed
        self.last = last
    }

    func timeSinceLast(now: Date) -> TimeInterval? { elapsed }

    func nextTargetDate(now: Date) -> Date? { last?.addingTimeInterval(targetInterval) }

    func progress(now: Date) -> Double {
        guard let elapsed, targetInterval > 0 else { return 0 }
        return min(max(elapsed / targetInterval, 0), 1)
    }
}
