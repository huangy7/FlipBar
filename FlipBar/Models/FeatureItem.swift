import Foundation

enum FeatureKind {
    case toggle
    case action
}

struct FeatureItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let kind: FeatureKind
    var isEnabled: Bool
}

enum FeatureCatalog {
    static func makeInitialItems() -> [FeatureItem] {
        [
            FeatureItem(
                id: HideDesktopIconsFeature.id,
                title: "Hide Desktop Icons",
                subtitle: "Temporarily hide desktop files and folders.",
                icon: "desktopcomputer",
                kind: .toggle,
                isEnabled: false
            ),
            FeatureItem(
                id: PreventSleepFeature.id,
                title: "Keep Awake",
                subtitle: "Prevent your Mac from sleeping.",
                icon: "cup.and.saucer",
                kind: .toggle,
                isEnabled: false
            ),
            FeatureItem(
                id: StartScreenSaverFeature.id,
                title: "Start Screen Saver",
                subtitle: "Launch the current screen saver now.",
                icon: "sparkles.tv",
                kind: .action,
                isEnabled: false
            ),
            FeatureItem(
                id: KeyboardCleaningFeature.id,
                title: "Keyboard Cleaning",
                subtitle: "Block most keyboard input while cleaning.",
                icon: "keyboard",
                kind: .toggle,
                isEnabled: false
            )
        ]
    }
}
