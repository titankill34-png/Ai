import Foundation
import SwiftData

/// SwiftData record for a single smoking event: when it happened, how strong the
/// craving was (0–10), and an optional free-text note.
@Model
final class SmokeLog {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var cravingScore: Int
    var note: String?

    init(id: UUID = UUID(), timestamp: Date = .now, cravingScore: Int = 0, note: String? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.cravingScore = cravingScore
        self.note = note
    }
}

extension SmokeLog {
    /// Storage-agnostic snapshot for the `SmokeLogStoring` boundary.
    var entry: SmokeLogEntry {
        SmokeLogEntry(id: id, timestamp: timestamp, cravingScore: cravingScore, note: note)
    }
}
