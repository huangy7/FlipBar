import AppKit
import ApplicationServices
import SwiftUI

@MainActor
final class KeyboardCleaningService {
    static let shared = KeyboardCleaningService()

    private let permission = AccessibilityPermissionService()
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var overlayWindows: [NSWindow] = []

    private(set) var isEnabled = false

    private init() {}

    func start() throws {
        guard !isEnabled else { return }

        guard permission.isTrusted(prompt: true) else {
            throw AppError.permissionRequired("Keyboard Cleaning requires Accessibility permission. Open System Settings > Privacy & Security > Accessibility, allow FlipBar, then try again.")
        }

        try startEventTap()
        showOverlay()
        isEnabled = true
    }

    func stop() {
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
        overlayWindows.forEach { $0.close() }
        overlayWindows.removeAll()
        isEnabled = false
    }

    private func startEventTap() throws {
        let mask = CGEventMask(1 << CGEventType.keyDown.rawValue) |
            CGEventMask(1 << CGEventType.keyUp.rawValue) |
            CGEventMask(1 << CGEventType.flagsChanged.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: { _, type, event, _ in
                switch type {
                case .keyDown, .keyUp, .flagsChanged:
                    return nil
                default:
                    return Unmanaged.passUnretained(event)
                }
            },
            userInfo: nil
        ) else {
            throw AppError.commandFailed("Unable to start keyboard event interception.")
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        if let runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    private func showOverlay() {
        let screens = NSScreen.screens.isEmpty ? [NSScreen.main].compactMap { $0 } : NSScreen.screens
        overlayWindows = screens.map { screen in
            let view = KeyboardCleaningOverlayView { [weak self] in
                self?.stop()
            }

            let window = NSWindow(
                contentRect: screen.frame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
            window.contentView = NSHostingView(rootView: view)
            window.isReleasedWhenClosed = false
            window.level = .screenSaver
            window.backgroundColor = NSColor.windowBackgroundColor
            return window
        }

        NSApp.activate(ignoringOtherApps: true)
        overlayWindows.first?.makeKeyAndOrderFront(nil)
        overlayWindows.dropFirst().forEach { $0.orderFrontRegardless() }
    }
}
