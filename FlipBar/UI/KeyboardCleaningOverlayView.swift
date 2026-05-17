import SwiftUI

struct KeyboardCleaningOverlayView: View {
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "keyboard")
                .font(.system(size: 52))

            Text("Keyboard Cleaning Mode")
                .font(.title2.bold())

            Text("Most keyboard input is being blocked while you clean. This is not hardware-level keyboard disabling and may not block every system key.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 460)

            Button("Exit Cleaning Mode") {
                onExit()
            }
            .keyboardShortcut(.cancelAction)
        }
        .padding(40)
    }
}
