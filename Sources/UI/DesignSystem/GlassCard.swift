import SwiftUI

/// Glassmorphic card surface: translucent material, hairline stroke, soft shadow,
/// continuous rounded corners. Wrap any content with `.glassCard()`.
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 24
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial, in: shape)
            .overlay(shape.strokeBorder(NicoraColor.glassStroke, lineWidth: 1))
            .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}

extension View {
    /// Renders this view inside a Nicora glass card.
    func glassCard(cornerRadius: CGFloat = 24, padding: CGFloat = 16) -> some View {
        modifier(GlassCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

#Preview {
    ZStack {
        GradientBackground()
        Text("Glass Card")
            .font(.nicoraHeadline)
            .foregroundStyle(NicoraColor.textPrimary)
            .glassCard()
            .padding()
    }
}
