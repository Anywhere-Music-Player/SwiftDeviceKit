#if os(iOS)
import SwiftDeviceKitSystem
import UIKit
import XCTest

@MainActor
final class OrientationTests: XCTestCase {
  func testMonitoringBalancesNestedRequests() {
    let device = UIDevice.current
    let initial = device.isGeneratingDeviceOrientationNotifications
    Device.beginOrientationUpdates()
    XCTAssertTrue(device.isGeneratingDeviceOrientationNotifications)
    Device.beginOrientationUpdates()
    Device.endOrientationUpdates()
    XCTAssertTrue(device.isGeneratingDeviceOrientationNotifications)
    Device.endOrientationUpdates()
    XCTAssertEqual(device.isGeneratingDeviceOrientationNotifications, initial)
  }
}
#endif
