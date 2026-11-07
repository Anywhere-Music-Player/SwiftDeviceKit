import XCTest
@testable import SwiftDeviceKitCore

final class CatalogIssueRegressionTests: XCTestCase {
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
  }

  func testXSeriesReplacementPreservesPhoneMembershipAndOrder() {
    XCTAssertEqual(Device.allPhonesWithSensorHousing, Device.allPhones.filter(\.hasSensorHousing))
    XCTAssertEqual(Device.allXSeriesDevices, Device.allPhonesWithSensorHousing)
    XCTAssertTrue(Device.allDevicesWithSensorHousing.contains(where: \.isMac))
  }

  func testIdentityDoesNotDependOnDisplayNames() {
    for model in Device.allRealDevices {
      for value in [model, .simulator(model), .simulator(.simulator(model))] {
        let unknown = Device.unknown(value.description)
        XCTAssertNotEqual(unknown, value)
        XCTAssertFalse(Device.allRealDevices.contains(unknown))
        XCTAssertFalse(unknown.hasBiometricSensor)
        XCTAssertFalse(unknown.hasUSBCConnectivity)
        XCTAssertEqual(unknown.cpu, .unknown)
        XCTAssertEqual(unknown, .unknown(value.description))
        XCTAssertNotEqual(unknown, .unknown(value.description + "!"))
      }
      XCTAssertEqual(Device.simulator(model), .simulator(model))
      XCTAssertNotEqual(model, .simulator(model))
      XCTAssertNotEqual(Device.simulator(model), .simulator(.simulator(model)))
    }
  }

  func testNestedSimulatorsPreserveEveryCatalogCapability() {
    let capabilities: [KeyPath<Device, Bool>] = [
      \.isTouchIDCapable, \.isFaceIDCapable, \.hasBiometricSensor, \.hasSensorHousing,
      \.hasRoundedDisplayCorners, \.hasDynamicIsland, \.has3dTouchSupport,
      \.supportsWirelessCharging, \.has5gSupport, \.hasEsimSupport, \.hasDualEsimSupport,
      \.hasLidarSensor, \.hasUSBCConnectivity, \.isFoldable,
      \.hasCamera, \.hasWideCamera, \.hasUltraWideCamera, \.hasTelephotoCamera,
    ]
    for model in Device.allRealDevices + [.unknown("future-model"), .unknown("iPhone 16 Pro")] {
      var wrapped = model
      for _ in 0..<8 {
        wrapped = .simulator(wrapped)
        XCTAssertTrue(wrapped.isSimulator)
        XCTAssertEqual(wrapped.realDevice, model)
        XCTAssertEqual(Device.realDevice(from: wrapped), model)
        XCTAssertEqual(wrapped.cpu, model.cpu)
        XCTAssertEqual(wrapped.screens, model.screens)
        XCTAssertEqual(wrapped.cameras, model.cameras)
        XCTAssertEqual(wrapped.applePencilSupport, model.applePencilSupport)
        for capability in capabilities {
          XCTAssertEqual(wrapped[keyPath: capability], model[keyPath: capability], "\(model)")
        }
      }
    }
  }

  func testM5PencilCompatibilityExcludesSecondGeneration() {
    for model in [Device.iPadPro11M5, .iPadPro13M5] {
      for value in [model, .simulator(model), .simulator(.simulator(model))] {
        XCTAssertEqual(value.applePencilSupport, [.firstGenerationUsbC, .pro])
        XCTAssertFalse(value.applePencilSupport.contains(.secondGeneration))
      }
    }
  }

  func testCatalogUsesPortraitReferenceDimensions() {
    let expected: [(Device, Double, Double)] = [
      (.iPadAir11M2, 41, 59), (.iPadAir11M3, 41, 59), (.iPadAir11M4, 41, 59),
      (.iPadAir13M2, 512, 683), (.iPadAir13M3, 512, 683), (.iPadAir13M4, 512, 683),
      (.iPadPro11M4, 417, 605), (.iPadPro11M5, 417, 605),
      (.iPadPro13M4, 3, 4), (.iPadPro13M5, 3, 4),
    ]
    for (model, width, height) in expected {
      for value in [model, .simulator(model), .simulator(.simulator(model))] {
        XCTAssertEqual(value.screenRatio.width, width)
        XCTAssertEqual(value.screenRatio.height, height)
      }
    }
    for model in Device.allRealDevices {
      for screen in model.screens {
        XCTAssertGreaterThan(screen.screenRatio.width, 0)
        XCTAssertLessThanOrEqual(screen.screenRatio.width, screen.screenRatio.height, "\(model)")
        if let resolution = screen.resolution {
          XCTAssertLessThanOrEqual(resolution.width, resolution.height)
          XCTAssertEqual(Double(resolution.width) / Double(resolution.height),
                         screen.screenRatio.width / screen.screenRatio.height, accuracy: 1e-12)
        }
      }
    }
  }

  func testMiniA20ProVerifiedIdentifiersAndSpecifications() throws {
    // IDs: Apple's Xcode 27.2 iPad mini (A20 Pro) profile, representedModelIdentifiers.
    // Hardware: https://www.apple.com/ipad-mini/specs/ (7 November 2026).
    for identifier in ["iPad19,1", "iPad19,2"] {
      let model = Device.mapToDevice(identifier: identifier)
      XCTAssertEqual(model, .iPadMiniA20Pro)
      XCTAssertEqual(model.description, "iPad mini (A20 Pro)")
      XCTAssertTrue(Device.allPads.contains(model))
      XCTAssertTrue(Device.allMiniDevices.contains(model))
      XCTAssertTrue(Device.allApplePencilCapableDevices.contains(model))
      XCTAssertTrue(Device.allSimulatorMiniDevices.contains(.simulator(model)))
      XCTAssertFalse(Device.allProDevices.contains(model))
      XCTAssertFalse(Device.allPlusSizedDevices.contains(model))
      for value in [model, .simulator(model), .simulator(.simulator(model))] {
        XCTAssertEqual(value.cpu, .a20Pro)
        XCTAssertEqual(value.cameras, [.wide])
        XCTAssertEqual(value.applePencilSupport, [.firstGenerationUsbC, .pro])
        XCTAssertTrue(value.isTouchIDCapable)
        XCTAssertTrue(value.hasRoundedDisplayCorners)
        XCTAssertTrue(value.has5gSupport)
        XCTAssertTrue(value.hasEsimSupport)
        XCTAssertTrue(value.hasUSBCConnectivity)
        XCTAssertFalse(value.isFaceIDCapable)
        XCTAssertFalse(value.hasDualEsimSupport)
        XCTAssertFalse(value.hasLidarSensor)
        XCTAssertFalse(value.isFoldable)
        XCTAssertFalse(value.hasDynamicIsland)
        XCTAssertFalse(value.supportsWirelessCharging)
        let screen = try XCTUnwrap(value.screen(.main))
        XCTAssertEqual(value.screens.count, 1)
        XCTAssertEqual(screen.diagonal, 8.5)
        XCTAssertEqual(screen.ppi, 326)
        XCTAssertEqual(screen.resolution?.width, 1512)
        XCTAssertEqual(screen.resolution?.height, 2316)
        XCTAssertEqual(screen.screenRatio.width, 126)
        XCTAssertEqual(screen.screenRatio.height, 193)
      }
    }
    for identifier in ["iPad19,0", "iPad19,3", "iPad19,1 ", "iPad mini (A20 Pro)"] {
      XCTAssertEqual(Device.mapToDevice(identifier: identifier), .unknown(identifier))
    }
  }
}
