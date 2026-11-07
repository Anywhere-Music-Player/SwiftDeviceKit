#if (os(iOS) && !targetEnvironment(macCatalyst)) || os(watchOS) || os(visionOS)
import Testing
@testable import SwiftDeviceKitSystem

@MainActor
struct ReportedBatteryStateTests {
  @Test func unknownReadingDependsOnExecutionEnvironment() {
    typealias State = Device.BatteryState
    #expect(State(reportedState: .unknown, level: -1, model: .iPhoneXS) == nil)
    #expect(State(reportedState: .unknown, level: 1, model: .iPhoneXS) == nil)
    for vision: Device in [.appleVisionProM2, .unidentifiedVision(reportedIdentifier: "masked")] {
      #expect(State(reportedState: .unknown, level: -1, model: .simulator(vision)) == nil)
    }
    let simulated = State(reportedState: .unknown, level: -1, model: .simulator(.iPhoneXS))
    #if os(visionOS)
      #expect(simulated == nil)
    #else
      #expect(simulated == .full)
    #endif
  }

  @Test func reportedStateAndValidLevelArePreserved() {
    typealias State = Device.BatteryState
    #expect(State(reportedState: .full, level: 1, model: .iPhoneXS) == .full)
    #expect(State(reportedState: .charging, level: 0.52, model: .iPhoneXS) == .charging(52))
    #expect(State(reportedState: .unplugged, level: 0.97, model: .iPhoneXS) == .unplugged(97))
    #expect(State(reportedState: .unplugged, level: -1, model: .iPhoneXS) == nil)
  }
}
#endif
