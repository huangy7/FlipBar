import Foundation

final class ScreenSaverService {
    private let runner = SystemCommandRunner()

    func start() async throws {
        let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
        let result = try await runner.run("/usr/bin/open", arguments: [path])

        guard result.exitCode == 0 else {
            throw AppError.commandFailed("Unable to start screen saver on this macOS version.")
        }
    }
}
