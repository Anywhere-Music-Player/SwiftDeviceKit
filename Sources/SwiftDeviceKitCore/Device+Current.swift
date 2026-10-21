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
