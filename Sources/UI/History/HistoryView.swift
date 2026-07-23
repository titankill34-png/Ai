import SwiftUI

/// A scrollable timeline of past logs grouped by day, over the Nicora gradient.
/// Each day is a glass card; each row shows time, an optional note, and the
/// craving score.
struct HistoryView: View {
    @StateObject private var model: HistoryViewModel

    init(model: HistoryViewModel) {
        _model = StateObject(wrappedValue: model)
    }

    var body: some View {
        ZStack {
            GradientBackground()
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        if model.sections.isEmpty {
            emptyState
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(model.sections) { section in
                        daySection(section)
                    }
                }
                .padding()
            }
        }
    }

    private func daySection(_ section: HistoryViewModel.DaySection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.day, format: .dateTime.weekday(.wide).month().day())
                .font(.nicoraHeadline)
                .foregroundStyle(NicoraColor.textSecondary)

            VStack(spacing: 10) {
                ForEach(section.entries) { entry in
                    entryRow(entry)
                }
            }
            .glassCard(padding: 16)
        }
    }

    private func entryRow(_ entry: SmokeLogEntry) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.timestamp, format: .dateTime.hour().minute())
                    .font(.nicoraBody)
                    .foregroundStyle(NicoraColor.textPrimary)
                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.nicoraCaption)
                        .foregroundStyle(NicoraColor.textSecondary)
                }
            }
            Spacer()
            cravingBadge(entry.cravingScore)
        }
    }

    private func cravingBadge(_ score: Int) -> some View {
        Text("\(score)")
            .font(.nicoraCaption)
            .foregroundStyle(NicoraColor.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(NicoraColor.glassHighlight, in: Capsule())
            .overlay(Capsule().strokeBorder(NicoraColor.glassStroke, lineWidth: 1))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.badge.checkmark")
                .font(.system(size: 44))
                .foregroundStyle(NicoraColor.textSecondary)
            Text("No logs yet")
                .font(.nicoraTitle)
                .foregroundStyle(NicoraColor.textPrimary)
            Text("Your logged moments will appear here, grouped by day.")
                .font(.nicoraBody)
                .foregroundStyle(NicoraColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    HistoryView(model: HistoryViewModel(store: SmokeLogStoringMock()))
}
