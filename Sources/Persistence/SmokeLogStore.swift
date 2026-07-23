import Foundation
import SwiftData

/// SwiftData-backed implementation of `SmokeLogStoring`.
final class SmokeLogStore: SmokeLogStoring {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Convenience initializer that builds an in-memory container (previews/tests).
    convenience init(inMemory: Bool = false) throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        let container = try ModelContainer(for: SmokeLog.self, configurations: config)
        self.init(context: ModelContext(container))
    }

    @discardableResult
    func add(timestamp: Date, cravingScore: Int, note: String?) throws -> SmokeLogEntry {
        let log = SmokeLog(timestamp: timestamp, cravingScore: cravingScore, note: note)
        context.insert(log)
        try context.save()
        return log.entry
    }

    func all() throws -> [SmokeLogEntry] {
        let descriptor = FetchDescriptor<SmokeLog>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try context.fetch(descriptor).map(\.entry)
    }

    func delete(id: UUID) throws {
        let target = id
        let descriptor = FetchDescriptor<SmokeLog>(
            predicate: #Predicate { $0.id == target }
        )
        for log in try context.fetch(descriptor) {
            context.delete(log)
        }
        try context.save()
    }
}
