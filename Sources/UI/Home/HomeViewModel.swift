import Foundation
import SwiftUI

/// Drives the Home screen: the live count-up since the last log, progress toward
/// the current target, and the three primary actions.
///
/// Built entirely against protocols (`IntervalProviding`, `SmokeLogStoring`) so it
/// runs on mocks in previews and the real engines in the app — never referencing a
/// concrete type from Jimmy's lane (CLAUDE.md §3).
@MainActor
final class HomeViewModel: ObservableObject {
    private let interval: IntervalProviding
    private let store: SmokeLogStoring

    /// Set when an action fails; surfaced to the user as a lightweight message.
    @Published var errorMessage: String?

    /// Hooks the tab bar (#14) wires to the Craving / Stats destinations. Home
    /// only signals intent — it owns no navigation itself.
    var onAddCraving: () -> Void = {}
    var onViewStats: () -> Void = {}

    init(interval: IntervalProviding, store: SmokeLogStoring) {
        self.interval = interval
        self.store = store
    }

    // MARK: Read model

    /// The current target the user is aiming for, formatted (e.g. "1h 30m").
    var targetText: String {
        Self.durationFormatter.string(from: interval.targetInterval) ?? "—"
    }

    /// Time since the last log at `now`, as a count-up clock ("H:MM:SS"), or a
    /// placeholder when there are no logs yet.
    func elapsedText(at now: Date) -> String {
        guard let elapsed = interval.timeSinceLast(now: now) else { return "—:—" }
        return Self.clockFormatter.string(from: elapsed) ?? "—:—"
    }

    /// Progress toward the current target in `[0, 1]`.
    func progress(at now: Date) -> Double { interval.progress(now: now) }

    /// Whether the user has reached the current target since the last log.
    func isOnTrack(at now: Date) -> Bool { interval.isOnTrack(now: now) }

    // MARK: Actions

    /// Log a smoking event now with the given craving score.
    func logNow(cravingScore: Int = 3) {
        do {
            try store.add(cravingScore: cravingScore, note: nil)
            errorMessage = nil
        } catch {
            errorMessage = "Couldn't save that log."
        }
    }

    // MARK: Formatters

    private static let clockFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute, .second]
        f.zeroFormattingBehavior = .pad
        f.unitsStyle = .positional
        return f
    }()

    private static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.unitsStyle = .abbreviated
        return f
    }()
}
