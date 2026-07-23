import SwiftUI

/// Placeholder root view. Real screens are built under `Sources/UI/**` in the
/// `lane:tony` UI tasks and wired into a tab bar; this keeps the bootstrap app
/// launchable and CI green until then.
struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "lungs.fill")
                .font(.system(size: 48))
            Text("Nicora")
                .font(.largeTitle.bold())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
