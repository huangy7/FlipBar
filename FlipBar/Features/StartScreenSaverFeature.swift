import Foundation

final class StartScreenSaverFeature: ActionFeature {
    static let id = "start-screen-saver"

    let title = "Start Screen Saver"
    let subtitle = "Launch the current screen saver now."
    let icon = "sparkles.tv"

    private let service = ScreenSaverService()

    func perform() async throws {
        try await service.start()
    }
}
