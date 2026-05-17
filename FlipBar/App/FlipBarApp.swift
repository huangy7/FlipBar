import SwiftUI

@main
struct FlipBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var viewModel = MenuBarViewModel()

    var body: some Scene {
        MenuBarExtra("FlipBar", image: "MenuBarIcon") {
            MenuBarView(viewModel: viewModel)
                .onAppear {
                    Task { await viewModel.refreshAll() }
                }
        }
        .menuBarExtraStyle(.window)
    }
}
