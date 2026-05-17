import Foundation

protocol FeatureModule {
    static var id: String { get }
    var title: String { get }
    var subtitle: String { get }
    var icon: String { get }
}

protocol ToggleFeature: FeatureModule {
    func isEnabled() async throws -> Bool
    func setEnabled(_ enabled: Bool) async throws
}

protocol ActionFeature: FeatureModule {
    func perform() async throws
}
