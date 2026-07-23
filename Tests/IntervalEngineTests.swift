import XCTest
@testable import Nicora

final class IntervalEngineTests: XCTestCase {
    private let base = Date(timeIntervalSince1970: 1_700_000_000)

    private func entries(_ offsetsMinutes: [Double]) -> [SmokeLogEntry] {
        offsetsMinutes.map {
            SmokeLogEntry(timestamp: base.addingTimeInterval($0 * 60), cravingScore: 1)
        }
    }

    func testNoEntriesUsesBaseTargetAndNilElapsed() {
        let engine = IntervalEngine(entries: [], config: .default)
        XCTAssertEqual(engine.targetInterval, IntervalConfig.default.baseInterval)
        XCTAssertNil(engine.timeSinceLast(now: base))
        XCTAssertNil(engine.nextTargetDate(now: base))
        XCTAssertEqual(engine.progress(now: base), 0)
    }

    func testComplianceLengthensGoal() {
        // Three 60-min gaps, each ≥ the 45-min base → grows by 1.1 three times.
        let engine = IntervalEngine(entries: entries([0, 60, 120, 180]), config: .default)
        let expected = 45.0 * 60.0 * pow(1.1, 3)
        XCTAssertEqual(engine.targetInterval, expected, accuracy: 0.001)
    }

    func testMissesNeverGoBelowBase() {
        // Three 10-min gaps, all < base → shrink is floored at base.
        let engine = IntervalEngine(entries: entries([0, 10, 20, 30]), config: .default)
        XCTAssertEqual(engine.targetInterval, IntervalConfig.default.baseInterval, accuracy: 0.001)
    }

    func testGoalIsCappedAtMax() {
        var config = IntervalConfig.default
        config.maxInterval = config.baseInterval * 1.05   // cap below one growth step
        let engine = IntervalEngine(entries: entries([0, 60, 120]), config: config)
        XCTAssertEqual(engine.targetInterval, config.maxInterval, accuracy: 0.001)
    }

    func testTimeSinceLastProgressAndNextTarget() {
        // One 60-min gap → target = 45 * 1.1 min.
        let logs = entries([0, 60])
        let engine = IntervalEngine(entries: logs, config: .default)
        let now = base.addingTimeInterval(120 * 60)            // 60 min after the last log
        let target = 45.0 * 60.0 * 1.1

        XCTAssertEqual(engine.timeSinceLast(now: now)!, 60 * 60, accuracy: 0.001)
        XCTAssertEqual(engine.progress(now: now), min(1, 60 * 60 / target), accuracy: 0.001)
        XCTAssertEqual(engine.nextTargetDate(now: now)!,
                       logs.last!.timestamp.addingTimeInterval(target))
        XCTAssertTrue(engine.isOnTrack(now: now))
    }

    func testUnsortedEntriesAreHandled() {
        let engine = IntervalEngine(entries: entries([180, 0, 120, 60]), config: .default)
        // Same as the sorted compliance case.
        XCTAssertEqual(engine.targetInterval, 45.0 * 60.0 * pow(1.1, 3), accuracy: 0.001)
    }
}
