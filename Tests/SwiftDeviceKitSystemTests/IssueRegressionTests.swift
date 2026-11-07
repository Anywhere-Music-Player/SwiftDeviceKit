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
