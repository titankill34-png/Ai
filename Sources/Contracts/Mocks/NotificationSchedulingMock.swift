import Foundation

/// Records calls instead of touching the notification center — for tests and previews.
final class NotificationSchedulingMock: NotificationScheduling {
    var authorizationResult = true
    private(set) var authorizationRequested = false
    private(set) var scheduledDates: [Date] = []
    private(set) var cancelCount = 0

    @discardableResult
    func requestAuthorization() async -> Bool {
        authorizationRequested = true
        return authorizationResult
    }

    func scheduleNext(at date: Date) async {
        scheduledDates.append(date)
    }

    func cancelAll() {
        cancelCount += 1
    }
}
