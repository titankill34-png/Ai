import SwiftUI
import SwiftData

@main
struct NicoraApp: App {
    private let container: ModelContainer
    private let store: SmokeLogStore
    private let interval: IntervalEngine
    private let stats: StatsEngine

    init() {
        // Single SwiftData container is the app's source of truth.
        let container: ModelContainer
        do {
            container = try ModelContainer(for: SmokeLog.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        self.container = container

        let store = SmokeLogStore(context: ModelContext(container))
        self.store = store

        // Engines are snapshots over the current history at launch. They take the
        // Contracts protocols; only the app entry references the concrete types.
        let entries = (try? store.all()) ?? []
        self.interval = IntervalEngine(entries: entries)
        self.stats = StatsEngine(entries: entries)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(interval: interval, stats: stats, store: store)
        }
    }
}
