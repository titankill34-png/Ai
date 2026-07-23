import SwiftUI

/// SF Rounded typography scale for Nicora.
///
/// Prefer these tokens over raw `.font(...)` so every screen shares one rounded,
/// friendly type ramp.
extension Font {
    /// Build a rounded font for a semantic Nicora text style.
    static func nicora(_ style: NicoraTextStyle) -> Font {
        .system(style.textStyle, design: .rounded).weight(style.weight)
    }

    // Convenience tokens.
    static let nicoraLargeTitle = nicora(.largeTitle)
    static let nicoraTitle = nicora(.title)
    static let nicoraHeadline = nicora(.headline)
    static let nicoraBody = nicora(.body)
    static let nicoraCaption = nicora(.caption)

    /// Large monospaced-digit numeral for the hero count-up timer (issue #9).
    static let nicoraTimer = Font.system(size: 52, weight: .bold, design: .rounded)
        .monospacedDigit()
}

/// Semantic text styles in the Nicora scale.
enum NicoraTextStyle {
    case largeTitle, title, headline, body, caption

    var textStyle: Font.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title
        case .headline: return .headline
        case .body: return .body
        case .caption: return .caption
        }
    }

    var weight: Font.Weight {
        switch self {
        case .largeTitle: return .bold
        case .title: return .semibold
        case .headline: return .semibold
        case .body: return .regular
        case .caption: return .medium
        }
    }
}
