import SwiftDeviceKitCore
import Testing

@Suite("iPhone Duo catalog support")
struct iPhoneDuoTests {
  @Test
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
      #expect(Device.allPhones.contains(device.realDevice))
      #expect(!Device.allPads.contains(device.realDevice))
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
  func bothScreensMatchAppleSpecifications() throws {
    // https://www.apple.com/iphone-duo/specs/ (verified 2026-10-21).
    // Use Apple's published hardware values, not the differing CoreSimulator profile.
    for device in [Device.iPhoneDuo, .simulator(.iPhoneDuo)] {
      #expect(device.screens.map(\.role) == [.outer, .inner])
      #expect(device.screen(.main) == nil)
      let outer = try #require(device.screen(.outer))
      let outerResolution = try #require(outer.resolution)
      #expect(outer.diagonal == 5.4)
      #expect(outer.ppi == 460)
      #expect(outerResolution.width == 1398)
      #expect(outerResolution.height == 2034)
      #expect(outer.screenRatio.width == 233)
      #expect(outer.screenRatio.height == 339)

      let inner = try #require(device.screen(.inner))
      let innerResolution = try #require(inner.resolution)
      #expect(inner.diagonal == 7.6)
      #expect(inner.ppi == 430)
      #expect(innerResolution.width == 1878)
      #expect(innerResolution.height == 2670)
      #expect(inner.screenRatio.width == 313)
      #expect(inner.screenRatio.height == 445)
    }
  }

  @Test
  func scalarMetricsDescribeTheOuterScreen() throws {
    for device in [Device.iPhoneDuo, .simulator(.iPhoneDuo)] {
      let outer = try #require(device.screen(.outer))
      #expect(device.diagonal == outer.diagonal)
      #expect(device.ppi == outer.ppi)
      #expect(device.screenRatio.width == outer.screenRatio.width)
      #expect(device.screenRatio.height == outer.screenRatio.height)
    }
  }
}
