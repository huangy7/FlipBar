import Foundation

final class KeyboardCleaningFeature: ToggleFeature {
    static let id = "keyboard-cleaning"

    let title = "Keyboard Cleaning"
    let subtitle = "Block most keyboard input while cleaning."
    let icon = "keyboard"

    private let service = KeyboardCleaningService.shared

    func isEnabled() async throws -> Bool {
        service.isEnabled
    }

    func setEnabled(_ enabled: Bool) async throws {
        if enabled {
            try service.start()
        } else {
            service.stop()
        }
    }
}
