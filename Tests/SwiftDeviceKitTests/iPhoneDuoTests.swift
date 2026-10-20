import Testing

@testable import SwiftDeviceKit

@Suite("iPhone Duo catalog support")
struct iPhoneDuoTests {
  @Test @MainActor
  func identifierAndFamily() {
    #expect(Device.mapToDevice(identifier: "iPhone19,4") == .iPhoneDuo)
    #expect(
      Device.mapToDevice(identifier: "placeholder:iPhoneDuo") == .unknown("placeholder:iPhoneDuo"))
    #expect(Device.allPhones.filter { $0 == .iPhoneDuo }.count == 1)
    #expect(Device.allRealDevices.contains(.iPhoneDuo))
    #expect(Device.allSimulators.contains(.simulator(.iPhoneDuo)))
    for device in [Device.iPhoneDuo, .simulator(.iPhoneDuo)] {
      #expect(device.realDevice.description == "iPhone Duo")
      #expect(device.realDevice.safeDescription == "iPhone Duo")
      #expect(device.isPhone)
      #expect(!device.isPad)
      #expect(device.isFoldable)
      #expect(device.cpu == .a20Pro)
    }
    #expect(Device.simulator(.iPhoneDuo).isSimulator)
    #expect(!Device.iPhoneDuo.isSimulator)
    for device in Device.allRealDevices where device != .iPhoneDuo {
      #expect(!device.isFoldable)
      #expect(!Device.simulator(device).isFoldable)
    }
    #expect(!Device.unknown("future-model").isFoldable)
  }

  @Test
  func verifiedCapabilities() {
    // Apple technical specifications, verified 2026-10-21; hardware is not queried.
    for device in [Device.iPhoneDuo, .simulator(.iPhoneDuo)] {
      #expect(device.isTouchIDCapable)
      #expect(!device.isFaceIDCapable)
      #expect(device.hasDynamicIsland)
      #expect(device.hasRoundedDisplayCorners)
      #expect(device.hasUSBCConnectivity)
      #expect(device.supportsWirelessCharging)
      #expect(device.has5gSupport)
      #expect(device.hasEsimSupport)
      #expect(device.hasDualEsimSupport)
      #expect(device.applePencilSupport == .firstGenerationUsbC)
      #expect(device.cameras == [.wide, .ultraWide])
      #expect(!device.hasTelephotoCamera)
    }
  }

  @Test
  func scalarDisplayMetricsDoNotGuessTheActivePanel() {
    for device in [Device.iPhoneDuo, .simulator(.iPhoneDuo)] {
      #expect(device.diagonal == -1)
      #expect(device.ppi == nil)
      #expect(device.screenRatio.width == -1)
      #expect(device.screenRatio.height == -1)
    }
  }
}
