import Foundation
import Testing

@testable import SwiftDeviceKitCore

private struct Baseline: Decodable {
  let caseName: String
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
  @Test
  func everySupportedIdentifierAndModelKeepsItsMetadata() throws {
    let url = try #require(Bundle.module.url(forResource: "DeviceKit-5.9.0", withExtension: "json"))
    let baseline = try JSONDecoder().decode([Baseline].self, from: Data(contentsOf: url))
    #expect(baseline.count == 99)
    #expect(Set(baseline.flatMap(\.identifiers)).count == baseline.flatMap(\.identifiers).count)
    let supported = baseline.filter {
      !CatalogSupportPolicy.excludedCaseNames.contains($0.caseName)
    }
    #expect(supported.count == 65)  // Duo and mini A20 Pro are covered separately.
    for expected in supported {
      for identifier in expected.identifiers {
        let device = Device.mapToDevice(identifier: identifier)
        #expect(device.description == expected.description, "\(identifier)")
        #expect(device.safeDescription == expected.safeDescription, "\(identifier)")
        #expect(Device.allPhones.contains(device) == (expected.family == "phone"))
        #expect(Device.allPads.contains(device) == (expected.family == "pad"))
        for variant in [device, .simulator(device)] {
          #expect(variant.realDevice == device)
          #expect(variant.diagonal == expected.diagonal)
          let corrected = CatalogSupportPolicy.portraitRatios[expected.caseName]
          if let corrected {
            #expect(expected.screenRatio == [corrected.1, corrected.0])
          }
          #expect(variant.screenRatio.width == (corrected?.0 ?? expected.screenRatio[0]))
          #expect(variant.screenRatio.height == (corrected?.1 ?? expected.screenRatio[1]))
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
        == supported.filter { $0.family == "phone" }.map(\.description))
    #expect(
      Device.allPads.filter { $0 != .iPadMiniA20Pro }.map(\.description)
        == supported.filter { $0.family == "pad" }.map(\.description)
    )
  }

  @Test
  func unsupportedHardwareResolvesToUnknown() throws {
    let identifiers = try CatalogSupportPolicy.excludedIdentifiers()
    #expect(identifiers.count == 67)
    for identifier in identifiers {
      let model = Device.mapToDevice(identifier: identifier)
      #expect(model == .unknown(identifier))
      #expect(model.description == identifier)
      #expect(model.safeDescription == identifier)
      #expect(!Device.allRealDevices.contains(model))
      for variant in [model, .simulator(model)] {
        #expect(variant.screens.isEmpty)
        #expect(variant.cpu == .unknown)
        #expect(variant.cameras.isEmpty)
        #expect(variant.applePencilSupport.isEmpty)
      }
    }
  }

  @Test
  func oldestSupportedModelsRemainRegistered() {
    let boundaries: [(String, Device)] = [
      ("iPhone11,2", .iPhoneXS), ("iPhone11,4", .iPhoneXSMax), ("iPhone11,8", .iPhoneXR),
      ("iPhone12,8", .iPhoneSE2), ("iPad7,11", .iPad7), ("iPad11,3", .iPadAir3),
      ("iPad11,1", .iPadMini5), ("iPad8,1", .iPadPro11Inch), ("iPad8,5", .iPadPro12Inch3),
    ]
    for (identifier, model) in boundaries {
      #expect(Device.mapToDevice(identifier: identifier) == model)
      #expect(Device.allRealDevices.contains(model))
      #expect(Device.allSimulators.contains(.simulator(model)))
    }
    // iPad 7 supports iPadOS 18 despite using an older chip than iPhone XS/XR.
    #expect(Device.iPad7.cpu == .a10Fusion)
    #expect(Device.allPhones.count == 37)
    #expect(Device.allPads.count == 30)
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
  func simulatorCameraMetadataMatchesTheCatalogModel() {
    for model in Device.allRealDevices + [.unknown("future-model")] {
      let simulator = Device.simulator(model)
      #expect(simulator.cameras == model.cameras)
      #expect(simulator.hasCamera == model.hasCamera)
      #expect(simulator.hasWideCamera == model.hasWideCamera)
      #expect(simulator.hasUltraWideCamera == model.hasUltraWideCamera)
      #expect(simulator.hasTelephotoCamera == model.hasTelephotoCamera)
    }
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

}
