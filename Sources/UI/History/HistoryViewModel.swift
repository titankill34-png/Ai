import Foundation
import SwiftUI

/// Loads the log history through `SmokeLogStoring` and groups it into day sections
/// for the timeline. Protocol-only, so it runs on the mock in previews and the
/// real store in the app.
@MainActor
final class HistoryViewModel: ObservableObject {
    /// One day's worth of entries, newest first.
    struct DaySection: Identifiable {
        let day: Date
        let entries: [SmokeLogEntry]
        var id: Date { day }
    }

    private let store: SmokeLogStoring
    private let calendar: Calendar

    @Published private(set) var sections: [DaySection] = []
    @Published var errorMessage: String?

    init(store: SmokeLogStoring, calendar: Calendar = .current) {
        self.store = store
        self.calendar = calendar
        load()
    }

    /// Reload from the store and regroup by day.
    func load() {
        do {
            sections = Self.group(try store.all(), calendar: calendar)
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't load history."
        }
    }

    /// Delete an entry and refresh.
    func delete(_ entry: SmokeLogEntry) {
        do {
            try store.delete(id: entry.id)
            load()
        } catch {
            errorMessage = "Couldn't delete that log."
        }
    }

    private static func group(_ entries: [SmokeLogEntry], calendar: Calendar) -> [DaySection] {
        Dictionary(grouping: entries) { calendar.startOfDay(for: $0.timestamp) }
            .map { DaySection(day: $0.key, entries: $0.value.sorted { $0.timestamp > $1.timestamp }) }
            .sorted { $0.day > $1.day }
    }
}
