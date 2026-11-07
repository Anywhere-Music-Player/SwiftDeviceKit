// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

import Darwin
import Foundation

extension Device {
  /// Returns a `Device` representing the current device this software runs on.
  public static var current: Device {
    #if targetEnvironment(simulator)
      let model = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? identifier
      return .simulator(hardware(model))
    #else
      return hardware(identifier)
    #endif
  }

  /// The raw hardware identifier, or the simulator's architecture as reported by uname.
  public static let identifier: String = {
    #if os(macOS) || targetEnvironment(macCatalyst)
      return MacHost.model ?? "Mac"
    #else
      if MacHost.isIOSAppOnMac { return MacHost.model ?? "Mac" }
      var info = utsname()
      uname(&info)
      return withUnsafeBytes(of: &info.machine) {
        String(decoding: $0.prefix { $0 != 0 }, as: UTF8.self)
      }
    #endif
  }()

  private static func hardware(_ identifier: String) -> Device {
    DeviceCatalog.byIdentifier[identifier] ?? .unknown(identifier)
  }

  /// Architecture aliases require an actual simulated model supplied by CoreSimulator.
  public static func mapToDevice(identifier: String) -> Device {
    resolve(identifier: identifier,
            simulatorModelIdentifier: ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"])
  }

  static func resolve(identifier: String, simulatorModelIdentifier: String?) -> Device {
    if ["arm64", "x86_64", "i386"].contains(identifier), let simulatorModelIdentifier,
       !simulatorModelIdentifier.isEmpty {
      return .simulator(hardware(simulatorModelIdentifier))
    }
    return hardware(identifier)
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

/// Host information shared by native Mac and iOS compatibility processes.
package enum MacHost {
  package static var isIOSAppOnMac: Bool {
    #if targetEnvironment(macCatalyst)
      true
    #elseif os(iOS)
      ProcessInfo.processInfo.isiOSAppOnMac
    #else
      false
    #endif
  }

  static let model = string(for: "hw.model")
  package static let systemVersion = string(for: "kern.osproductversion")

  private static func string(for key: String) -> String? {
    var size = 0
    guard sysctlbyname(key, nil, &size, nil, 0) == 0, size > 1 else { return nil }
    var bytes = [UInt8](repeating: 0, count: size)
    guard sysctlbyname(key, &bytes, &size, nil, 0) == 0, size > 1 else { return nil }
    return String(bytes: bytes.prefix(size).prefix { $0 != 0 }, encoding: .utf8)
  }
}
