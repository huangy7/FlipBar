import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationWillTerminate(_ notification: Notification) {
        AppLifecycleCleanup.shared.cleanup()
    }
}

@MainActor
final class AppLifecycleCleanup {
    static let shared = AppLifecycleCleanup()

    private init() {}

    func cleanup() {
        PowerAssertionService.shared.disable()
        KeyboardCleaningService.shared.stop()
    }
}
