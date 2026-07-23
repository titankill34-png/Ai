import SwiftUI

/// Root tab bar wiring the five Nicora destinations: Home, Log, Stats, History,
/// Settings.
///
/// Dependencies are injected as protocols (never a concrete engine type —
/// CLAUDE.md §3). The app entry point supplies the real engines; previews use the
/// mocks. Each screen owns its own view model.
struct RootTabView: View {
    let interval: IntervalProviding
    let stats: StatsProviding
    let store: SmokeLogStoring

    var body: some View {
        TabView {
            HomeView(model: HomeViewModel(interval: interval, store: store))
                .tabItem { Label("Home", systemImage: "house.fill") }

            LogView(store: store)
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }

            StatsView(stats: stats, interval: interval)
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }

            HistoryView(model: HistoryViewModel(store: store))
                .tabItem { Label("History", systemImage: "clock.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(NicoraColor.textPrimary)
    }
}

#Preview {
    RootTabView(
        interval: IntervalProvidingMock(),
        stats: StatsProvidingMock(),
        store: SmokeLogStoringMock()
    )
}
