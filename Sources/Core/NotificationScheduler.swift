import Foundation
import UserNotifications

/// `UNUserNotificationCenter`-backed local reminder for the next target time.
/// Uses only local notifications — no Push Notifications entitlement (KSign-safe).
final class NotificationScheduler: NotificationScheduling {
    /// Single reusable request id so scheduling is idempotent.
    static let requestIdentifier = "nicora.next-target"

    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleNext(at date: Date) async {
        cancelAll()
        let interval = date.timeIntervalSinceNow
        guard interval > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Nicora"
        content.body = "You've reached your target interval — nice work. Keep the streak going."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(
            identifier: Self.requestIdentifier,
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    func cancelAll() {
        center.removePendingNotificationRequests(withIdentifiers: [Self.requestIdentifier])
    }
}
