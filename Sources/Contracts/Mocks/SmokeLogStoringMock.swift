import Foundation

/// In-memory `SmokeLogStoring` for SwiftUI previews, unit tests, and Tony's UI
/// work — no SwiftData container required.
final class SmokeLogStoringMock: SmokeLogStoring {
    private(set) var entries: [SmokeLogEntry]

    init(entries: [SmokeLogEntry] = SmokeLogStoringMock.sample) {
        self.entries = entries.sorted { $0.timestamp > $1.timestamp }
    }

    @discardableResult
    func add(timestamp: Date, cravingScore: Int, note: String?) throws -> SmokeLogEntry {
        let entry = SmokeLogEntry(timestamp: timestamp, cravingScore: cravingScore, note: note)
        entries.append(entry)
        entries.sort { $0.timestamp > $1.timestamp }
        return entry
    }

    func all() throws -> [SmokeLogEntry] { entries }

    func delete(id: UUID) throws {
        entries.removeAll { $0.id == id }
    }

    /// Deterministic-ish sample data for previews.
    static let sample: [SmokeLogEntry] = (0..<8).map { i in
        SmokeLogEntry(
            timestamp: Calendar.current.date(byAdding: .hour, value: -i * 5, to: .now) ?? .now,
            cravingScore: (i % 5) + 1,
            note: i.isMultiple(of: 3) ? "after coffee" : nil
        )
    }
}
