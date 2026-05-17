import Foundation

final class PreventSleepFeature: ToggleFeature {
    static let id = "prevent-sleep"

    let title = "Keep Awake"
    let subtitle = "Prevent your Mac from sleeping."
    let icon = "cup.and.saucer"

    private let service = PowerAssertionService.shared

    func isEnabled() async throws -> Bool {
        service.isKeepingAwake
    }

    func setEnabled(_ enabled: Bool) async throws {
        if enabled {
            try service.enable()
        } else {
            service.disable()
        }
    }
}
