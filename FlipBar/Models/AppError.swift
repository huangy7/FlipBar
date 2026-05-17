import Foundation

enum AppError: LocalizedError {
    case commandFailed(String)
    case permissionRequired(String)
    case unsupported(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .commandFailed(let message): return message
        case .permissionRequired(let message): return message
        case .unsupported(let message): return message
        case .unknown(let message): return message
        }
    }
}
