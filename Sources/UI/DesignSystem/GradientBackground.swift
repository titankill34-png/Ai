import SwiftUI

/// The app-wide blue gradient backdrop.
///
/// Put it at the root of a screen — either directly in a `ZStack` or via the
/// `.nicoraBackground()` modifier below.
struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: NicoraColor.backgroundGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

extension View {
    /// Places the Nicora gradient behind this view.
    func nicoraBackground() -> some View {
        background(GradientBackground())
    }
}

#Preview {
    GradientBackground()
}
