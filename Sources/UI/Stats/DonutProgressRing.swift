import SwiftUI

/// A donut progress ring showing actual progress toward the current goal — the
/// interval engine's elapsed-vs-target fraction — with an animated fill.
///
/// Reusable component: drive it with a raw `progress` value or the convenience
/// `init(interval:)`. Previews inject `IntervalProvidingMock`.
struct DonutProgressRing: View {
    /// Fraction filled; clamped to `[0, 1]` for display.
    let progress: Double
    var lineWidth: CGFloat = 18
    var caption: String = "of goal"

    @State private var animatedProgress: Double = 0

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(NicoraColor.glassHighlight, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    NicoraColor.textPrimary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text(clamped, format: .percent.precision(.fractionLength(0)))
                    .font(.nicoraTitle)
                    .foregroundStyle(NicoraColor.textPrimary)
                    .contentTransition(.numericText())
                Text(caption)
                    .font(.nicoraCaption)
                    .foregroundStyle(NicoraColor.textSecondary)
            }
        }
        .padding(lineWidth / 2)
        .onAppear { animate(to: clamped) }
        .onChange(of: clamped) { _, newValue in animate(to: newValue) }
    }

    private func animate(to value: Double) {
        withAnimation(.easeOut(duration: 0.8)) {
            animatedProgress = value
        }
    }
}

extension DonutProgressRing {
    /// Build the ring from the interval engine's progress toward the current target.
    init(
        interval: IntervalProviding,
        now: Date = .now,
        lineWidth: CGFloat = 18,
        caption: String = "of goal"
    ) {
        self.init(progress: interval.progress(now: now), lineWidth: lineWidth, caption: caption)
    }
}

#Preview {
    ZStack {
        GradientBackground()
        DonutProgressRing(interval: IntervalProvidingMock())
            .frame(width: 200, height: 200)
            .padding()
    }
}
