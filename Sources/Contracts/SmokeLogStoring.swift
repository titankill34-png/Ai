import Foundation

/// A storage-agnostic snapshot of a logged smoking event. Carries no SwiftData
/// (or any persistence) type, so UI and engines never depend on the storage layer.
struct SmokeLogEntry: Identifiable, Equatable, Sendable {
    let id: UUID
    let timestamp: Date
    let cravingScore: Int
    let note: String?

    init(id: UUID = UUID(), timestamp: Date, cravingScore: Int, note: String? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.cravingScore = cravingScore
        self.note = note
    }
}

/// Persistence boundary for smoking logs (CLAUDE.md cross-lane contract).
/// Concrete implementation lives in `Sources/Persistence`; the mock lives in
/// `Sources/Contracts/Mocks` so Tony is never blocked on the real store.
protocol SmokeLogStoring {
    /// Persist a new log and return its snapshot.
    @discardableResult
    func add(timestamp: Date, cravingScore: Int, note: String?) throws -> SmokeLogEntry
    /// All logs, newest first.
    func all() throws -> [SmokeLogEntry]
    /// Remove the log with the given id (no-op if absent).
    func delete(id: UUID) throws
}

extension SmokeLogStoring {
    /// Convenience for logging "now".
    @discardableResult
    func add(cravingScore: Int, note: String? = nil) throws -> SmokeLogEntry {
        try add(timestamp: .now, cravingScore: cravingScore, note: note)
    }
}
