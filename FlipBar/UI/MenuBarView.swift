import SwiftUI

struct MenuBarView: View {
    @ObservedObject var viewModel: MenuBarViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("FlipBar")
                    .font(.headline)
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
            }

            Divider()

            ForEach(viewModel.items) { item in
                FeatureItemView(item: item, viewModel: viewModel)
            }

            if let message = viewModel.errorMessage {
                ErrorBannerView(message: message)
            }
        }
        .padding(14)
        .frame(width: 340)
    }
}
