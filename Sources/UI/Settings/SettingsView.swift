import SwiftUI

/// App settings. Minimal for now — a styled list the tab bar wires in; real
/// controls (goal, reminders, economics) land in a later task.
struct SettingsView: View {
    var body: some View {
        ZStack {
            GradientBackground()
            VStack(spacing: 16) {
                Text("Settings")
                    .font(.nicoraLargeTitle)
                    .foregroundStyle(NicoraColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 0) {
                    settingRow(icon: "target", title: "Craving goal", detail: "Adaptive")
                    divider
                    settingRow(icon: "bell.fill", title: "Reminders", detail: "On")
                    divider
                    settingRow(icon: "info.circle.fill", title: "About Nicora", detail: "")
                }
                .glassCard(padding: 8)
                Spacer()
            }
            .padding()
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(NicoraColor.glassStroke)
            .frame(height: 1)
    }

    private func settingRow(icon: String, title: String, detail: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(NicoraColor.textSecondary)
                .frame(width: 24)
            Text(title)
                .font(.nicoraBody)
                .foregroundStyle(NicoraColor.textPrimary)
            Spacer()
            Text(detail)
                .font(.nicoraCaption)
                .foregroundStyle(NicoraColor.textSecondary)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(NicoraColor.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
    }
}

#Preview {
    SettingsView()
}
