import Foundation

final class FinderPreferenceService {
    private let runner = SystemCommandRunner()

    func areDesktopIconsHidden() async throws -> Bool {
        let result = try await runner.run(
            "/usr/bin/defaults",
            arguments: ["read", "com.apple.finder", "CreateDesktop"]
        )

        // Finder default: if key is missing or true, desktop icons are shown.
        let value = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return value == "0" || value == "false" || value == "no"
    }

    func setDesktopIconsHidden(_ hidden: Bool) async throws {
        if try await areDesktopIconsHidden() == hidden {
            return
        }

        let boolValue = hidden ? "false" : "true"
        let writeResult = try await runner.run(
            "/usr/bin/defaults",
            arguments: ["write", "com.apple.finder", "CreateDesktop", "-bool", boolValue]
        )

        guard writeResult.exitCode == 0 else {
            throw AppError.commandFailed("Unable to update Finder desktop icon setting.")
        }

        let refreshResult = try await runner.run("/usr/bin/killall", arguments: ["Finder"])
        guard refreshResult.exitCode == 0 else {
            throw AppError.commandFailed("Updated the Finder setting, but could not refresh Finder.")
        }
    }
}
