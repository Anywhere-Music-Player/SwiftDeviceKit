import SwiftDeviceKitCore
import Testing

@Suite("Catalog hardware capabilities")
struct HardwareCapabilityTests {
  @Test
  func actionButtonModels() {
    // https://support.apple.com/105103 distinguishes the Action button from Camera Control on Duo.
    let supported: [Device] = [
      .iPhone15Pro, .iPhone15ProMax,
      .iPhone16, .iPhone16Plus, .iPhone16Pro, .iPhone16ProMax, .iPhone16e,
      .iPhone17, .iPhone17Pro, .iPhone17ProMax, .iPhoneAir, .iPhone17e,
      .iPhone18Pro, .iPhone18ProMax,
    ]
    #expect(Device.allDevicesWithActionButton == supported)
    for model in Device.allRealDevices + [.unknown("iPhone99,1")] {
      for device in [model, .simulator(model), .simulator(.simulator(model))] {
        #expect(device.hasActionButton == supported.contains(model), "\(device)")
      }
    }
  }
}
