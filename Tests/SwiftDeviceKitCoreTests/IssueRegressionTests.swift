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
}
