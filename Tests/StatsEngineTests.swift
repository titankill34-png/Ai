import XCTest
@testable import Nicora

final class StatsEngineTests: XCTestCase {
    private var utc: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }

    private func day0(_ cal: Calendar) -> Date {
        cal.startOfDay(for: Date(timeIntervalSince1970: 1_700_000_000))
    }

    func testDailyCountsIncludeZeroDays() {
        let cal = utc
        let d0 = day0(cal)
        let logs = [
            SmokeLogEntry(timestamp: d0.addingTimeInterval(3600), cravingScore: 1),
            SmokeLogEntry(timestamp: d0.addingTimeInterval(7200), cravingScore: 1),
            SmokeLogEntry(timestamp: d0.addingTimeInterval(2 * 86400 + 3600), cravingScore: 1),
        ]
        let engine = StatsEngine(entries: logs, calendar: cal)
        let counts = engine.dailyCounts(range: d0...d0.addingTimeInterval(2 * 86400))
        XCTAssertEqual(counts.map(\.count), [2, 0, 1])
        XCTAssertEqual(counts.map(\.day), [d0, d0.addingTimeInterval(86400), d0.addingTimeInterval(2 * 86400)])
    }

    func testAverageInterval() {
        let start = Date(timeIntervalSince1970: 1_700_000_000)
        let logs = [0.0, 3600, 3 * 3600].map {
            SmokeLogEntry(timestamp: start.addingTimeInterval($0), cravingScore: 1)
        }
        // total span 10800s over 2 gaps → 5400s.
        XCTAssertEqual(StatsEngine(entries: logs, calendar: utc).averageInterval!, 5400, accuracy: 0.001)
    }

    func testAverageIntervalNilBelowTwoLogs() {
        XCTAssertNil(StatsEngine(entries: [], calendar: utc).averageInterval)
        let one = [SmokeLogEntry(timestamp: .init(timeIntervalSince1970: 1_700_000_000), cravingScore: 1)]
        XCTAssertNil(StatsEngine(entries: one, calendar: utc).averageInterval)
    }

    func testMoneySaved() {
        let cal = utc
        let d0 = day0(cal)
        // 3 logs spanning 2 days; baseline 10/day → expected 20, saved 17 units × 0.50.
        let logs = [
            SmokeLogEntry(timestamp: d0.addingTimeInterval(3600), cravingScore: 1),
            SmokeLogEntry(timestamp: d0.addingTimeInterval(7200), cravingScore: 1),
            SmokeLogEntry(timestamp: d0.addingTimeInterval(86400 + 3600), cravingScore: 1),
        ]
        let saved = StatsEngine(entries: logs, calendar: cal)
            .moneySaved(baselinePerDay: 10, unitCost: Decimal(string: "0.50")!)
        XCTAssertEqual(saved, Decimal(string: "8.5"))
    }

    func testMoneySavedNeverNegative() {
        let cal = utc
        let d0 = day0(cal)
        let logs = (0..<50).map { SmokeLogEntry(timestamp: d0.addingTimeInterval(Double($0) * 60), cravingScore: 1) }
        let saved = StatsEngine(entries: logs, calendar: cal)
            .moneySaved(baselinePerDay: 1, unitCost: Decimal(string: "0.50")!)
        XCTAssertEqual(saved, 0)
    }
}
