import SwiftUI

struct FeatureItemView: View {
    let item: FeatureItem
    @ObservedObject var viewModel: MenuBarViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 13, weight: .semibold))
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            switch item.kind {
            case .toggle:
                Button(item.isEnabled ? "On" : "Off") {
                    Task { await viewModel.setToggle(item.id, enabled: !item.isEnabled) }
                }
                .buttonStyle(ToggleButtonStyle(isEnabled: item.isEnabled))
            case .action:
                Button("Run") {
                    Task { await viewModel.performAction(item.id) }
                }
                .buttonStyle(ActionButtonStyle())
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ToggleButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(isEnabled ? .white : .primary)
            .frame(width: 54, height: 26)
            .background(isEnabled ? Color.accentColor : Color.secondary.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .opacity(configuration.isPressed ? 0.72 : 1)
    }
}

private struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .semibold))
            .frame(width: 54, height: 26)
            .background(Color.secondary.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            .opacity(configuration.isPressed ? 0.72 : 1)
    }
}
