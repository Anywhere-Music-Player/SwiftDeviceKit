#if os(macOS)
import IOKit.ps
import Testing
@testable import SwiftDeviceKitSystem

struct MacBatteryTests {
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
    #expect(!reading.state.description.contains("100"))
  }
}
#endif
