import XCTest
@testable import SwiftDeviceKitCore

final class CatalogIssueRegressionTests: XCTestCase {
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
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
}
