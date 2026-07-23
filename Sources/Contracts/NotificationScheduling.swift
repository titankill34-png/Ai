import Foundation

/// Schedules a single local reminder for the next craving target. Local
/// notifications need no entitlement, so this stays KSign-safe (CLAUDE.md §1) —
/// do not swap in remote/push notifications.
protocol NotificationScheduling {
    /// Ask the user for permission once. Returns whether it was granted.
    @discardableResult
    func requestAuthorization() async -> Bool
    /// Replace any pending reminder with one firing at `date` (ignored if in the past).
    func scheduleNext(at date: Date) async
    /// Cancel the pending reminder.
    func cancelAll()
}

extension NotificationScheduling {
    /// Reschedule from the interval engine's next target — call after each new log.
    func rescheduleNext(using interval: IntervalProviding, now: Date = .now) async {
        guard let next = interval.nextTargetDate(now: now) else {
            cancelAll()
            return
        }
        await scheduleNext(at: next)
    }
}
