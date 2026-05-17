import Combine
import Foundation

@MainActor
final class MenuBarViewModel: ObservableObject {
    @Published var items: [FeatureItem] = FeatureCatalog.makeInitialItems()
    @Published var errorMessage: String?

    private let hideDesktop = HideDesktopIconsFeature()
    private let keepAwake = PreventSleepFeature()
    private let screenSaver = StartScreenSaverFeature()
    private let keyboardCleaning = KeyboardCleaningFeature()

    func refreshAll() async {
        for item in items where item.kind == .toggle {
            do {
                let enabled = try await feature(for: item.id)?.isEnabled() ?? false
                updateItem(item.id, isEnabled: enabled)
            } catch {
                show(error)
            }
        }
    }

    func setToggle(_ id: String, enabled: Bool) async {
        do {
            try await feature(for: id)?.setEnabled(enabled)
            updateItem(id, isEnabled: enabled)
            errorMessage = nil
        } catch {
            show(error)
            await refreshAll()
        }
    }

    func performAction(_ id: String) async {
        do {
            try await action(for: id)?.perform()
            errorMessage = nil
        } catch {
            show(error)
        }
    }

    private func feature(for id: String) -> ToggleFeature? {
        switch id {
        case HideDesktopIconsFeature.id: return hideDesktop
        case PreventSleepFeature.id: return keepAwake
        case KeyboardCleaningFeature.id: return keyboardCleaning
        default: return nil
        }
    }

    private func action(for id: String) -> ActionFeature? {
        switch id {
        case StartScreenSaverFeature.id: return screenSaver
        default: return nil
        }
    }

    private func updateItem(_ id: String, isEnabled: Bool) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isEnabled = isEnabled
    }

    private func show(_ error: Error) {
        errorMessage = (error as? AppError)?.localizedDescription ?? error.localizedDescription
    }
}
