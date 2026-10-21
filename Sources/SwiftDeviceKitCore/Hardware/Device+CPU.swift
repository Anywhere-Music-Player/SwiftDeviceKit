// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  public enum CPU: Comparable, Sendable {
    case a10Fusion
    case a12Bionic
    case a12XBionic
    case a12ZBionic
    case a13Bionic
    case a14Bionic
    case a15Bionic
    case a16Bionic
    case a17Pro
    case a18
    case a18Pro
    case a19
    case a19Pro
    case a20Pro
    case m1
    case m2
    case m3
    case m4
    case m5
    case unknown
  }
}

extension Device.CPU: CustomStringConvertible {

  /// A textual representation of the device.
  public var description: String {
    switch self {
    case .a10Fusion: return "A10 Fusion"
    case .a12Bionic: return "A12 Bionic"
    case .a12XBionic: return "A12X Bionic"
    case .a12ZBionic: return "A12Z Bionic"
    case .a13Bionic: return "A13 Bionic"
    case .a14Bionic: return "A14 Bionic"
    case .a15Bionic: return "A15 Bionic"
    case .a16Bionic: return "A16 Bionic"
    case .a17Pro: return "A17 Pro"
    case .a18: return "A18"
    case .a18Pro: return "A18 Pro"
    case .a19: return "A19"
    case .a19Pro: return "A19 Pro"
    case .a20Pro: return "A20 Pro"
    case .m1: return "M1"
    case .m2: return "M2"
    case .m3: return "M3"
    case .m4: return "M4"
    case .m5: return "M5"
    case .unknown: return "unknown"
    }
  }
}
