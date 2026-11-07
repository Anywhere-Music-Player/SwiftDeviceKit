#if os(iOS)
import Foundation
import ObjectiveC
import Security
import UIKit
import XCTest
@testable import SwiftDeviceKitSystem

@MainActor
final class SystemIssueRegressionTests: XCTestCase {
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
  }

  func testUnknownDisplayNameCannotReadCurrentDeviceState() {
    let current = Device.current
    // On a Mac, use the compatibility iPad's display name as the impostor.
    let unknown = Device.unknown(ProcessInfo.processInfo.isiOSAppOnMac
      ? Device.iPadPro12Inch3.description : current.description)
    XCTAssertNotEqual(unknown, Device.current)
    XCTAssertNil(unknown.systemVersion)
    XCTAssertNil(unknown.batteryState)
    XCTAssertNil(unknown.isZoomed)
    XCTAssertFalse(unknown.isPhone)
    XCTAssertFalse(unknown.isPad)
  }

  func testNestedSimulatorFamilyMatchesUnderlyingModel() {
    for model in Device.allRealDevices + [.unknown("future-model")] {
      let wrapped = Device.simulator(.simulator(.simulator(model)))
      XCTAssertEqual(wrapped.isPhone, model.isPhone)
      XCTAssertEqual(wrapped.isPad, model.isPad)
    }
  }

  func testKnownCurrentModelKeepsItsFamilyWithTheOppositeUIIdiom() throws {
    let current = Device.current
    let isPad = Device.allPads.contains(current.realDevice)
    guard isPad || Device.allPhones.contains(current.realDevice) else {
      throw XCTSkip("Requires a cataloged iPhone or iPad")
    }
    let method = try XCTUnwrap(class_getInstanceMethod(
      UIDevice.self, #selector(getter: UIDevice.userInterfaceIdiom)))
    let opposite: UIUserInterfaceIdiom = isPad ? .phone : .pad
    let getter: @convention(block) (AnyObject) -> Int = { _ in opposite.rawValue }
    let replacement = imp_implementationWithBlock(getter)
    let original = method_setImplementation(method, replacement)
    defer {
      method_setImplementation(method, original)
      imp_removeBlock(replacement)
    }
    XCTAssertEqual(UIDevice.current.userInterfaceIdiom, opposite)
    XCTAssertEqual(current.isPad, isPad)
    XCTAssertEqual(current.isPhone, !isPad)
  }

  func testBrightnessReportsOnlyMeasuredPercentages() throws {
    let method = try XCTUnwrap(class_getInstanceMethod(UIScreen.self, #selector(getter: UIScreen.brightness)))
    let readings: [(CGFloat, Int?)] = [(-1, nil), (0, 0), (0.5, 50), (1, 100), (.nan, nil), (1.1, nil)]
    for (raw, expected) in readings {
      let getter: @convention(block) (AnyObject) -> CGFloat = { _ in raw }
      let replacement = imp_implementationWithBlock(getter)
      let original = method_setImplementation(method, replacement)
      defer {
        method_setImplementation(method, original)
        imp_removeBlock(replacement)
      }
      XCTAssertEqual(Device.current.screenBrightness, expected)
    }
  }

  func testZoomUsesActualScaleWithoutLegacyPlusAssumptions() throws {
    let scaleMethod = try XCTUnwrap(class_getInstanceMethod(UIScreen.self, #selector(getter: UIScreen.scale)))
    let nativeMethod = try XCTUnwrap(class_getInstanceMethod(UIScreen.self, #selector(getter: UIScreen.nativeScale)))
    // Normal/zoomed 2x and 3x screens; mini downsampling; iPad More Space.
    let inputs: [(CGFloat, CGFloat, Bool)] = [
      (2, 2, false), (2, 2.34375, true), (3, 3, false), (3, 3.375, true),
      (3, 2.88, false), (3, 2.7, false), (2, 1.8, false),
    ]
    for (scale, native, expected) in inputs {
      let scaleBlock: @convention(block) (AnyObject) -> CGFloat = { _ in scale }
      let nativeBlock: @convention(block) (AnyObject) -> CGFloat = { _ in native }
      let scaleIMP = imp_implementationWithBlock(scaleBlock)
      let nativeIMP = imp_implementationWithBlock(nativeBlock)
      let oldScale = method_setImplementation(scaleMethod, scaleIMP)
      let oldNative = method_setImplementation(nativeMethod, nativeIMP)
      defer {
        method_setImplementation(scaleMethod, oldScale)
        method_setImplementation(nativeMethod, oldNative)
        imp_removeBlock(scaleIMP)
        imp_removeBlock(nativeIMP)
      }
      XCTAssertEqual(Device.current.isZoomed, expected, "scale \(scale), nativeScale \(native)")
      XCTAssertNil(Device.unknown("other-device").isZoomed)
    }
  }

  func testBatteryOrderingIsTotalAndTransitive() {
    let states: [Device.BatteryState] = [0, 50, 75, 100].flatMap {
      [.unplugged($0), .charging($0)]
    } + [.full]
    for a in states {
      for b in states {
        XCTAssertEqual([a == b, a < b, b < a].filter { $0 }.count, 1, "\(a); \(b)")
        XCTAssertEqual(a <= b, a < b || a == b)
        XCTAssertEqual(a >= b, b < a || a == b)
        for c in states where a < b && b < c { XCTAssertLessThan(a, c) }
      }
    }
    for level in [0, 50, 75, 100] {
      XCTAssertLessThan(Device.BatteryState.unplugged(level), .charging(level))
      XCTAssertLessThan(Device.BatteryState.charging(level), .full)
    }
  }

  func testCapacityRefreshesWithinOneSynchronousOperation() throws {
    let before = try XCTUnwrap(Device.volumeAvailableCapacity)
    _ = Device.volumes
    guard before > 128 * 1024 * 1024 else { throw XCTSkip("Needs 128 MiB free for storage probe") }
    let file = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    defer { try? FileManager.default.removeItem(at: file) }
    var bytes = Data(count: 64 * 1024 * 1024)
    let status = bytes.withUnsafeMutableBytes {
      SecRandomCopyBytes(kSecRandomDefault, $0.count, $0.baseAddress!)
    }
    XCTAssertEqual(status, errSecSuccess)
    guard status == errSecSuccess else { return }
    try bytes.write(to: file)
    let handle = try FileHandle(forWritingTo: file)
    try handle.synchronize()
    try handle.close()
    let after = try XCTUnwrap(Device.volumeAvailableCapacity)
    let volumes = try XCTUnwrap(Device.volumes)
    let fresh = try XCTUnwrap(URL(fileURLWithPath: NSHomeDirectory())
      .resourceValues(forKeys: [.volumeAvailableCapacityKey]).volumeAvailableCapacity)
    guard before - fresh > 32 * 1024 * 1024 else {
      throw XCTSkip("Concurrent disk activity obscured the probe's allocation")
    }
    XCTAssertLessThan(abs(after - fresh), 16 * 1024 * 1024)
    XCTAssertLessThan(abs(try XCTUnwrap(volumes[.volumeAvailableCapacityKey]) - Int64(fresh)), 16 * 1024 * 1024)
  }
}
#endif
