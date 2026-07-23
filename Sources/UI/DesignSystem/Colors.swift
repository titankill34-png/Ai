import SwiftUI

/// Nicora color tokens — a calm blue palette shared by every screen.
///
/// Use these instead of raw `Color(...)` literals so the whole app stays on one
/// coherent ramp. Tokens only; no view here.
enum NicoraColor {
    // MARK: Brand blues (light → deep)

    static let skyBlue = Color(red: 0.36, green: 0.68, blue: 0.98)
    static let oceanBlue = Color(red: 0.16, green: 0.42, blue: 0.86)
    static let deepBlue = Color(red: 0.07, green: 0.20, blue: 0.52)

    /// Primary accent for interactive elements (buttons, selected tabs).
    static let accent = oceanBlue

    /// Stops for the app-wide background gradient (top-leading → bottom-trailing).
    static let backgroundGradient = [skyBlue, oceanBlue, deepBlue]

    // MARK: On-surface text (sits over the gradient / glass cards)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.75)

    // MARK: Glass surface tones

    static let glassStroke = Color.white.opacity(0.25)
    static let glassHighlight = Color.white.opacity(0.10)
}
