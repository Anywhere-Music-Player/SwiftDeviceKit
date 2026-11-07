#if os(watchOS)
import Foundation
import Testing
@testable import SwiftDeviceKitSystem

// Supply exact 64-bit Foundation values independently of the test host’s free disk space.
private final class LargeVolume: NSURL, @unchecked Sendable {
  override func getResourceValue(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>,
                                 forKey key: URLResourceKey) throws {
    switch key {
    case .volumeTotalCapacityKey: value.pointee = NSNumber(value: 64_000_000_000 as Int64)
    case .volumeAvailableCapacityKey: value.pointee = NSNumber(value: 4_294_967_297 as Int64)
    default: throw CocoaError(.featureUnsupported)
    }
  }
}

struct WatchStorageTests {
  @Test func capacityPreservesBytesAboveThe32BitRange() throws {
    let url = LargeVolume(fileURLWithPath: "/")
    let total: Int64 = 64_000_000_000
    let available: Int64 = 4_294_967_297

    #expect(Device.volumeCapacity(for: .volumeTotalCapacityKey, at: url) == total)
    #expect(Device.volumeCapacity(for: .volumeAvailableCapacityKey, at: url) == available)

    let liveTotal: Int64 = try #require(Device.volumeTotalCapacity)
    let liveAvailable: Int64 = try #require(Device.volumeAvailableCapacity)
    #expect(liveTotal > Int64(Int32.max))
    #expect((0...liveTotal).contains(liveAvailable))
  }
}
#endif
