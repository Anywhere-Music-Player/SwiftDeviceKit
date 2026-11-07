#if os(iOS) || os(watchOS) || os(visionOS)
import Testing
@testable import SwiftDeviceKitSystem

@MainActor
struct ReportedBatteryStateTests {
  @Test func unknownReadingDependsOnExecutionEnvironment() {
    typealias State = Device.BatteryState
    #expect(State(reportedState: .unknown, level: -1, isSimulator: false) == nil)
    #expect(State(reportedState: .unknown, level: 1, isSimulator: false) == nil)
    let simulated = State(reportedState: .unknown, level: -1, isSimulator: true)
    #if os(visionOS)
      #expect(simulated == nil)
    #else
      #expect(simulated == .full)
    #endif
  }

  @Test func reportedStateAndValidLevelArePreserved() {
    typealias State = Device.BatteryState
    #expect(State(reportedState: .full, level: 1, isSimulator: false) == .full)
    #expect(State(reportedState: .charging, level: 0.52, isSimulator: false) == .charging(52))
    #expect(State(reportedState: .unplugged, level: 0.97, isSimulator: false) == .unplugged(97))
    #expect(State(reportedState: .unplugged, level: -1, isSimulator: false) == nil)
  }
}
#endif
