import SwiftUI

/// Quick log entry: capture a craving score (0–10) and an optional note, then save
/// through `SmokeLogStoring`.
struct LogView: View {
    let store: SmokeLogStoring

    @State private var cravingScore: Double = 3
    @State private var note: String = ""
    @State private var confirmation: String?

    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 24) {
                Text("Log a moment")
                    .font(.nicoraLargeTitle)
                    .foregroundStyle(NicoraColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                cravingCard
                noteCard
                saveButton

                if let confirmation {
                    Text(confirmation)
                        .font(.nicoraCaption)
                        .foregroundStyle(NicoraColor.textSecondary)
                }
                Spacer()
            }
            .padding()
        }
    }

    private var cravingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Craving")
                    .font(.nicoraHeadline)
                    .foregroundStyle(NicoraColor.textPrimary)
                Spacer()
                Text("\(Int(cravingScore))")
                    .font(.nicoraTitle)
                    .foregroundStyle(NicoraColor.textPrimary)
                    .contentTransition(.numericText())
            }
            Slider(value: $cravingScore, in: 0...10, step: 1)
                .tint(NicoraColor.textPrimary)
        }
        .glassCard(padding: 20)
    }

    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Note")
                .font(.nicoraHeadline)
                .foregroundStyle(NicoraColor.textPrimary)
            TextField("Optional", text: $note, axis: .vertical)
                .font(.nicoraBody)
                .foregroundStyle(NicoraColor.textPrimary)
                .lineLimit(1...3)
        }
        .glassCard(padding: 20)
    }

    private var saveButton: some View {
        Button(action: save) {
            Text("Log now")
                .font(.nicoraHeadline)
                .foregroundStyle(NicoraColor.textPrimary)
                .frame(maxWidth: .infinity)
                .glassCard(cornerRadius: 18, padding: 16)
        }
        .buttonStyle(.plain)
    }

    private func save() {
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            try store.add(cravingScore: Int(cravingScore), note: trimmed.isEmpty ? nil : trimmed)
            note = ""
            confirmation = "Logged."
        } catch {
            confirmation = "Couldn't save. Try again."
        }
    }
}

#Preview {
    LogView(store: SmokeLogStoringMock())
}
