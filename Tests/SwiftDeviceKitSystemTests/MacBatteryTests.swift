#if os(macOS) || targetEnvironment(macCatalyst)
import IOKit.ps
import Testing
@testable import SwiftDeviceKitSystem

struct MacBatteryTests {
  @Test func externalPowerCanPauseAndResumeChargingAtTheSameLevel() throws {
    var source: [String: Any] = [
      kIOPSTypeKey: kIOPSInternalBatteryType,
      kIOPSPowerSourceStateKey: kIOPSACPowerValue,
      kIOPSCurrentCapacityKey: 80,
      kIOPSMaxCapacityKey: 100,
      kIOPSIsChargedKey: false,
      kIOPSIsChargingKey: false,
    ]
    let paused = try #require(MacBatteryReading(source: source))
    #expect(paused.state == .pluggedInNotCharging(80))
    #expect(paused.level == 80)

    source[kIOPSIsChargingKey] = true
    #expect(MacBatteryReading(source: source)?.state == .charging(80))
    source.removeValue(forKey: kIOPSIsChargingKey)
    #expect(MacBatteryReading(source: source)?.state == nil)
    #expect(MacBatteryReading(source: source)?.level == 80)
    source[kIOPSPowerSourceStateKey] = kIOPSBatteryPowerValue
    source[kIOPSIsChargingKey] = false
    #expect(MacBatteryReading(source: source)?.state == .unplugged(80))
  }

  @Test func pausedStateKeepsBatteryOrderByLevelThenPowerState() {
    let ordered: [Device.BatteryState] = [
      .charging(79), .unplugged(80), .pluggedInNotCharging(80), .charging(80),
      .unplugged(81), .charging(100), .full,
    ]
    for (index, state) in ordered.enumerated() {
      for (otherIndex, other) in ordered.enumerated() {
        #expect((state < other) == (index < otherIndex))
      }
    }
  }

  @Test(arguments: 95...100)
  func chargedFlagPreservesMeasuredPercentage(percent: Int) throws {
    let source: [String: Any] = [
      kIOPSTypeKey: kIOPSInternalBatteryType,
      kIOPSPowerSourceStateKey: kIOPSACPowerValue,
      kIOPSIsChargedKey: true,
      kIOPSCurrentCapacityKey: percent * 10,
      kIOPSMaxCapacityKey: 1000,
    ]
    let reading = try #require(MacBatteryReading(source: source))
    #expect(reading.state == .full)
    #expect(reading.level == percent)
    let state = try #require(reading.state)
    #expect(!state.description.contains("100"))
  }
}
#endif
