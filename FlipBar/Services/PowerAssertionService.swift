import Foundation
import IOKit.pwr_mgt

@MainActor
final class PowerAssertionService {
    static let shared = PowerAssertionService()

    private var idleSleepAssertionID: IOPMAssertionID = 0
    private var displaySleepAssertionID: IOPMAssertionID = 0

    var isKeepingAwake: Bool {
        idleSleepAssertionID != 0 || displaySleepAssertionID != 0
    }

    private init() {}

    func enable() throws {
        guard !isKeepingAwake else { return }

        let reason = "FlipBar Keep Awake" as CFString
        var idleAssertion: IOPMAssertionID = 0
        let idleResult = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoIdleSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &idleAssertion
        )

        guard idleResult == kIOReturnSuccess else {
            throw AppError.commandFailed("Failed to enable Keep Awake.")
        }

        var displayAssertion: IOPMAssertionID = 0
        let displayResult = IOPMAssertionCreateWithName(
            kIOPMAssertionTypeNoDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &displayAssertion
        )

        guard displayResult == kIOReturnSuccess else {
            IOPMAssertionRelease(idleAssertion)
            throw AppError.commandFailed("Failed to keep the display awake.")
        }

        idleSleepAssertionID = idleAssertion
        displaySleepAssertionID = displayAssertion
    }

    func disable() {
        guard isKeepingAwake else { return }

        if idleSleepAssertionID != 0 {
            IOPMAssertionRelease(idleSleepAssertionID)
            idleSleepAssertionID = 0
        }

        if displaySleepAssertionID != 0 {
            IOPMAssertionRelease(displaySleepAssertionID)
            displaySleepAssertionID = 0
        }
    }
}
