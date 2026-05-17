import Foundation

final class HideDesktopIconsFeature: ToggleFeature {
    static let id = "hide-desktop-icons"

    let title = "Hide Desktop Icons"
    let subtitle = "Temporarily hide desktop files and folders."
    let icon = "desktopcomputer"

    private let service = FinderPreferenceService()

    func isEnabled() async throws -> Bool {
        try await service.areDesktopIconsHidden()
    }

    func setEnabled(_ enabled: Bool) async throws {
        try await service.setDesktopIconsHidden(enabled)
    }
}
