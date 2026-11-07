import Foundation
@testable import SwiftDeviceKitCore
import Testing

@Suite("Cross-platform catalog")
struct PlatformCatalogTests {
  @Test func matchesAppleComputerInventory() throws {
    // Apple macOS IPSW catalog (DFU models), Sequoia compatibility and Apple's model identification
    // articles for Intel, and Apple Software Lookup Service for visionOS. See Docs/PlatformSupport.md.
    struct Inventory: Decodable {
      let intelMac: Set<String>
      let appleSiliconMac: Set<String>
      let vision: Set<String>
    }
    let url = try #require(Bundle.module.url(forResource: "AppleComputerIdentifiers", withExtension: "json"))
    let inventory = try JSONDecoder().decode(Inventory.self, from: Data(contentsOf: url))
    let macs = DeviceCatalog.all.filter { $0.family == .mac }
    #expect(Set(macs.filter { $0.cpu == .intel }.flatMap(\.identifiers)) == inventory.intelMac)
    #expect(Set(macs.filter { $0.cpu != .intel }.flatMap(\.identifiers)) == inventory.appleSiliconMac)
    #expect(Set(DeviceCatalog.all.filter { $0.family == .vision }.flatMap(\.identifiers)) == inventory.vision)
  }

  @Test func macMini2024IdentifiersMatchTheirChips() {
    // Apple macOS 15 Sequoia Validation Report, table 2 (A3238 and A3239).
    let base = Device.mapToDevice(identifier: "Mac16,10")
    let pro = Device.mapToDevice(identifier: "Mac16,11")
    #expect(base == .macMiniM4)
    #expect(base.cpu == .m4)
    #expect(pro == .macMiniM4Pro)
    #expect(pro.cpu == .m4Pro)
  }

  @Test func boundariesAndAppleIdentifiers() {
    let examples: [(String, Device, Device.Family)] = [
      ("Watch6,3", .appleWatchSeries6_40mm, .watch),
      ("Watch6,8", .appleWatchSeries7_41mm, .watch),
      ("Watch7,2", .appleWatchSeries9_45mm, .watch),
      ("Watch7,14", .appleWatchSE3_44mm, .watch), ("Watch7,15", .appleWatchSE3_40mm, .watch),
      ("Watch8,5", .appleWatchSeries12_46mm, .watch), ("Watch8,1", .appleWatchUltra4, .watch),
      ("AppleTV5,3", .appleTVHD, .tv), ("AppleTV18,1", .appleTV4K4, .tv),
      ("RealityDevice14,1", .appleVisionProM2, .vision), ("RealityDevice17,1", .appleVisionProM5, .vision),
      ("iMacPro1,1", .iMacPro, .mac), ("MacBookAir9,1", .macBookAir13Intel2020, .mac),
      ("Mac17,5", .macBookNeo, .mac), ("Mac18,1", .macBookPro14M6, .mac),
      ("Mac18,2", .iMac24M6, .mac), ("Mac18,5", .macMiniM6, .mac),
    ]
    for (identifier, device, family) in examples {
      #expect(Device.mapToDevice(identifier: identifier) == device)
      #expect(device.family == family)
      #expect(Device.simulator(device).family == family)
    }
    for id in ["Watch5,1", "Watch5,9", "AppleTV3,2", "MacBookAir8,2", "iMac18,3", "RealityDevice99,1"] {
      #expect(Device.mapToDevice(identifier: id) == .unknown(id))
      #expect(Device.mapToDevice(identifier: id).family == nil)
    }
  }

  @Test func simulatorGroupsContainOnlySupportedSimulatorsInCatalogOrder() {
    let groups: [([Device], [Device])] = [
      (Device.allSimulatorMiniDevices, Device.allMiniDevices),
      (Device.allSimulatorProDevices, Device.allProDevices),
      (Device.allSimulatorPlusSizedDevices, Device.allPlusSizedDevices),
      (Device.allSimulatorDevicesWithSensorHousing, Device.allDevicesWithSensorHousing),
      (Device.allSimulatorXSeriesDevices, Device.allDevicesWithSensorHousing),
    ]
    let simulators = Device.allSimulators
    #expect(!simulators.contains { $0.isMac })
    for (group, hardware) in groups {
      let expected = hardware.map(Device.simulator).filter(simulators.contains)
      #expect(group == expected)
    }
  }

  @Test func ultra2UsesApplesProductName() {
    let watch = Device.mapToDevice(identifier: "Watch7,5")
    #expect(watch == .appleWatchUltra2)
    #expect(watch.description == "Apple Watch Ultra 2")
    #expect(watch.safeDescription == "Apple Watch Ultra 2")
    #expect(Device.simulator(watch).safeDescription == "Simulator (Apple Watch Ultra 2)")
  }

  @Test func platformCapabilitiesAndLists() {
    #expect(Device.allWatches.count == 22)
    #expect(Device.allTVs.count == 5)
    #expect(Device.allVisions.count == 2)
    #expect(Device.allMacs.count == 77)
    #expect(Device.allSimulatorWatches == Device.allWatches.map(Device.simulator))
    #expect(Device.allSimulatorTVs == Device.allTVs.map(Device.simulator))
    #expect(Device.allRealDevices == Device.allPhones + Device.allPads + Device.allWatches + Device.allTVs + Device.allVisions + Device.allMacs)
    #expect(Device.allWatches.allSatisfy { $0.hasRoundedDisplayCorners && !$0.hasForceTouchSupport })
    #expect(Device.appleWatchSE3_40mm.has5gSupport)
    #expect(!Device.appleWatchSE2_40mm.has5gSupport)
    #expect(Device.appleWatchUltra2.ppi == 326)
    #expect(Device.appleWatchUltra3.screen(.main)?.resolution?.height == 514)
    #expect(Device.appleTV4K4.screens.isEmpty)
    #expect(Device.appleTVHD.hasUSBCConnectivity)
    #expect(Device.appleTV4K4.cpu == .a19)
    #expect(Device.macMiniM6.screens.isEmpty)
    #expect(Device.macBookPro16M5MaxPROLED.hasDynamicIsland)
    #expect(Device.macBookPro16M5MaxPROLED.screen(.main)?.resolution?.height == 3472)
    #expect(Device.appleVisionProM5.isOpticIDCapable)
    #expect(Device.appleVisionProM5.hasBiometricSensor)
    #expect(Device.appleVisionProM5.hasCamera)
    #expect(Device.appleVisionProM5.hasUSBCConnectivity)
    #expect(Device.appleVisionProM2.spatialDisplay?.refreshRatesHz == [90, 96, 100])
    #expect(Device.simulator(.appleVisionProM5).spatialDisplay?.refreshRatesHz == [90, 96, 100, 120])
    #expect(Device.appleVisionProM5.hasLidarSensor)
  }
}
