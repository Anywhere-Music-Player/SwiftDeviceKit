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
