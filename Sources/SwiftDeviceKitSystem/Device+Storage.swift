// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

import Foundation
public import SwiftDeviceKitCore

// MARK: DiskSpace
extension Device {

  /// Return the root url
  ///
  /// - returns: the NSHomeDirectory() url
  // URL resource values are cached per instance. Each query must start with a fresh URL,
  // including consecutive reads before the main run loop has a chance to clear its cache.
  private static var rootURL: URL { URL(fileURLWithPath: NSHomeDirectory()) }

  /// The volume’s total capacity in bytes.
  public static var volumeTotalCapacity: Int? {
    return (try? Device.rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey]))?
      .volumeTotalCapacity
  }

  /// The volume’s available capacity in bytes.
  public static var volumeAvailableCapacity: Int? {
    return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey]))?
      .volumeAvailableCapacity
  }

  #if !os(watchOS) && !os(tvOS)
  /// The volume’s available capacity in bytes for storing important resources.

  public static var volumeAvailableCapacityForImportantUsage: Int64? {
    return (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]))?
      .volumeAvailableCapacityForImportantUsage
  }

  /// The volume’s available capacity in bytes for storing nonessential resources.

  public static var volumeAvailableCapacityForOpportunisticUsage: Int64? {  // swiftlint:disable:this identifier_name
    return
      (try? rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]))?
      .volumeAvailableCapacityForOpportunisticUsage
  }

  /// All volumes capacity information in bytes.

  public static var volumes: [URLResourceKey: Int64]? {
    do {
      let values = try rootURL.resourceValues(forKeys: [
        .volumeAvailableCapacityForImportantUsageKey,
        .volumeAvailableCapacityKey,
        .volumeAvailableCapacityForOpportunisticUsageKey,
        .volumeTotalCapacityKey,
      ])
      return values.allValues.mapValues {
        if let int = $0 as? Int64 {
          return int
        }
        if let int = $0 as? Int {
          return Int64(int)
        }
        return 0
      }
    } catch {
      return nil
    }
  }
  #endif
}
