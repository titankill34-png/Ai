import SwiftUI

/// The Home screen: a hero count-up card over the Nicora gradient, plus the three
/// primary actions (Log now / Craving / Stats).
struct HomeView: View {
    @StateObject private var model: HomeViewModel

    init(model: HomeViewModel) {
        _model = StateObject(wrappedValue: model)
    }

    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 28) {
                heroCard
                actionRow
                Spacer()
            }
            .padding()
        }
    }

    // Re-evaluates once a second so the count-up ticks live off the interval engine.
    private var heroCard: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            VStack(spacing: 12) {
                Text("Since last")
                    .font(.nicoraHeadline)
                    .foregroundStyle(NicoraColor.textSecondary)

                Text(model.elapsedText(at: context.date))
                    .font(.nicoraTimer)
                    .foregroundStyle(NicoraColor.textPrimary)
                    .contentTransition(.numericText())

                ProgressView(value: model.progress(at: context.date))
                    .tint(NicoraColor.textPrimary)

                Text(model.isOnTrack(at: context.date)
                     ? "Target reached — \(model.targetText)"
                     : "Target \(model.targetText)")
                    .font(.nicoraCaption)
                    .foregroundStyle(NicoraColor.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .glassCard(padding: 24)
        }
    }

    private var actionRow: some View {
        HStack(spacing: 12) {
            actionButton("Log now", systemImage: "plus.circle.fill") { model.logNow() }
            actionButton("Craving", systemImage: "heart.fill") { model.onAddCraving() }
            actionButton("Stats", systemImage: "chart.bar.fill") { model.onViewStats() }
        }
    }

    private func actionButton(
        _ title: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.nicoraCaption)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(NicoraColor.textPrimary)
            .glassCard(cornerRadius: 18, padding: 14)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(model: HomeViewModel(
        interval: IntervalProvidingMock(),
        store: SmokeLogStoringMock()
    ))
}
