import Foundation
import Testing

@testable import SwiftDeviceKit

private struct Baseline: Decodable {
  let identifiers: [String]
  let description: String
  let safeDescription: String
  let diagonal: Double
  let screenRatio: [Double]
  let ppi: Int
  let family: String
  let hasTouchID: Bool
  let hasFaceID: Bool
  let hasSensorHousing: Bool
  let hasRoundedDisplayCorners: Bool
  let hasDynamicIsland: Bool
  let hasForce3dTouchSupport: Bool
  let supportsWirelessCharging: Bool
  let hasLidarSensor: Bool
  let hasUSBCConnectivity: Bool
  let has5gSupport: Bool
  let hasEsimSupport: Bool
  let hasDualEsimSupport: Bool
}

@Suite("DeviceKit 5.9.0 catalog baseline")
struct CatalogBaselineTests {
  @Test @MainActor
  func everyIdentifierAndModelKeepsItsMetadata() throws {
    let url = try #require(Bundle.module.url(forResource: "DeviceKit-5.9.0", withExtension: "json"))
    let baseline = try JSONDecoder().decode([Baseline].self, from: Data(contentsOf: url))
    #expect(baseline.count == 99)
    #expect(Set(baseline.flatMap(\.identifiers)).count == baseline.flatMap(\.identifiers).count)
    for expected in baseline {
      for identifier in expected.identifiers {
        let device = Device.mapToDevice(identifier: identifier)
        #expect(device.description == expected.description, "\(identifier)")
        #expect(device.safeDescription == expected.safeDescription, "\(identifier)")
        #expect(device.isPhone == (expected.family == "phone"))
        #expect(device.isPad == (expected.family == "pad"))
        #expect(device.isPod == (expected.family == "pod"))
        for variant in [device, .simulator(device)] {
          #expect(variant.realDevice == device)
          #expect(variant.diagonal == expected.diagonal)
          #expect(variant.screenRatio.width == expected.screenRatio[0])
          #expect(variant.screenRatio.height == expected.screenRatio[1])
          #expect(variant.ppi == expected.ppi)
          #expect(variant.isTouchIDCapable == expected.hasTouchID)
          #expect(variant.isFaceIDCapable == expected.hasFaceID)
          #expect(variant.hasSensorHousing == expected.hasSensorHousing)
          #expect(variant.hasRoundedDisplayCorners == expected.hasRoundedDisplayCorners)
          #expect(variant.hasDynamicIsland == expected.hasDynamicIsland)
          #expect(variant.has3dTouchSupport == expected.hasForce3dTouchSupport)
          #expect(variant.supportsWirelessCharging == expected.supportsWirelessCharging)
          #expect(variant.hasLidarSensor == expected.hasLidarSensor)
          #expect(variant.hasUSBCConnectivity == expected.hasUSBCConnectivity)
          #expect(variant.has5gSupport == expected.has5gSupport)
          #expect(variant.hasEsimSupport == expected.hasEsimSupport)
          #expect(variant.hasDualEsimSupport == expected.hasDualEsimSupport)
        }
      }
    }
    #expect(
      Device.allPhones.filter { $0 != .iPhoneDuo }.map(\.description)
        == baseline.filter { $0.family == "phone" }.map(\.description))
    #expect(
      Device.allPads.map(\.description) == baseline.filter { $0.family == "pad" }.map(\.description)
    )
    #expect(
      Device.allPods.map(\.description) == baseline.filter { $0.family == "pod" }.map(\.description)
    )
  }

  @Test
  func unknownModelsRemainIdentifiable() {
    let identifier = "iPhone999,42"
    let device = Device.mapToDevice(identifier: identifier)
    #expect(device == .unknown(identifier))
    #expect(device.description == identifier)
    #expect(device.safeDescription == identifier)
    #expect(device.diagonal == -1)
    #expect(device.ppi == nil)
    #expect(device.cpu == .unknown)
    #expect(!device.isSimulator)
    let simulator = Device.simulator(device)
    #expect(simulator.isSimulator)
    #expect(simulator.realDevice == device)
    #expect(simulator.description == "Simulator (\(identifier))")
  }

  @Test
  func catalogCanCrossActorBoundaries() async {
    let device = Device.iPhone13Pro
    let result = await Task.detached {
      let current = Device.current
      return (device, device.cpu, device.applePencilSupport, current.description, Device.identifier)
    }.value
    #expect(result.0 == device)
    #expect(result.1 == .a15Bionic)
    #expect(result.2.isEmpty)
    #expect(!result.3.isEmpty)
    #expect(!result.4.isEmpty)
  }

  @Test @MainActor
  func runtimeStateOnlyAppliesToCurrentModel() {
    let other = Device.unknown("unavailable-test-model")
    #expect(other.name == nil)
    #expect(other.systemName == nil)
    #expect(other.systemVersion == nil)
    #expect(other.model == nil)
    #expect(other.localizedModel == nil)
    #expect(other.isCanvas == nil)
    #expect(other.batteryState == nil)
    #expect(other.batteryLevel == nil)
    #expect(other.thermalState == nil)
    #expect(other.isZoomed == nil)
  }
}
