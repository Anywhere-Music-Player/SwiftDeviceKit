// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

import Darwin
import Foundation

extension Device {
  /// Returns a `Device` representing the current device this software runs on.
  public static var current: Device {
    return Device.mapToDevice(identifier: Device.identifier)
  }

  /// Gets the identifier from the system, such as "iPhone19,2".
  public static let identifier: String = {
    if IOSAppOnMac.isRunning {
      // uname reports a compatibility iPad for an iOS app running on a Mac.
      return IOSAppOnMac.hostModel ?? "Mac"
    }
    var systemInfo = utsname()
    uname(&systemInfo)
    let mirror = Mirror(reflecting: systemInfo.machine)

    let identifier = mirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }()

  /// Resolves a hardware identifier, including the simulator architecture identifiers.
  public static func mapToDevice(identifier: String) -> Device {
    resolve(
      identifier: identifier,
      simulatorModelIdentifier: ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"])
  }

  /// Explicit environment input keeps identifier resolution deterministic and testable.
  static func resolve(identifier: String, simulatorModelIdentifier: String?) -> Device {
    switch identifier {
    case "i386", "x86_64", "arm64":
      let modelIdentifier = simulatorModelIdentifier ?? "iOS"
      return .simulator(DeviceCatalog.byIdentifier[modelIdentifier] ?? .unknown(modelIdentifier))
    default:
      return DeviceCatalog.byIdentifier[identifier] ?? .unknown(identifier)
    }
  }

  /// Returns whether the current device is a SwiftUI preview canvas
  public var isCanvas: Bool? {
    guard self == Device.current else { return nil }
    #if DEBUG
      return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    #else
      return false
    #endif
  }
}

/// Host information for an iOS binary running directly on macOS.
package enum IOSAppOnMac {
  package static var isRunning: Bool {
    #if os(iOS)
      ProcessInfo.processInfo.isiOSAppOnMac
    #else
      false
    #endif
  }

  static let hostModel = string(for: "hw.model")
  package static let systemVersion = string(for: "kern.osproductversion")

  private static func string(for key: String) -> String? {
    var size = 0
    guard sysctlbyname(key, nil, &size, nil, 0) == 0, size > 1 else { return nil }
    var bytes = [UInt8](repeating: 0, count: size)
    guard sysctlbyname(key, &bytes, &size, nil, 0) == 0, size > 1 else { return nil }
    return String(bytes: bytes.prefix(size).prefix { $0 != 0 }, encoding: .utf8)
  }
}
