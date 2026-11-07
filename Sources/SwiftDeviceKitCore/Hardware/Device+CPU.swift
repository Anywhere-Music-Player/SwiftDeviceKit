// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  public enum CPU: Comparable, Sendable {
    case a8
    case a10Fusion
    case a10XFusion
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
    case m1Pro
    case m1Max
    case m1Ultra
    case m2
    case m2Pro
    case m2Max
    case m2Ultra
    case m3
    case m3Pro
    case m3Max
    case m3Ultra
    case m4
    case m4Pro
    case m4Max
    case m5
    case s6
    case s7
    case s8
    case s9
    case s10
    case s11
    case intel
    case m5Pro
    case m5Max
    case m5Ultra
    case m6
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
    case .a8: return "A8"
    case .a10XFusion: return "A10X Fusion"
    case .s6: return "S6"
    case .s7: return "S7"
    case .s8: return "S8"
    case .s9: return "S9"
    case .s10: return "S10"
    case .s11: return "S11"
    case .intel: return "Intel"
    case .m1Pro: return "M1 Pro"
    case .m1Max: return "M1 Max"
    case .m1Ultra: return "M1 Ultra"
    case .m2Pro: return "M2 Pro"
    case .m2Max: return "M2 Max"
    case .m2Ultra: return "M2 Ultra"
    case .m3Pro: return "M3 Pro"
    case .m3Max: return "M3 Max"
    case .m3Ultra: return "M3 Ultra"
    case .m4Pro: return "M4 Pro"
    case .m4Max: return "M4 Max"
    case .m5Pro: return "M5 Pro"
    case .m5Max: return "M5 Max"
    case .m5Ultra: return "M5 Ultra"
    case .m6: return "M6"
    case .unknown: return "unknown"
    }
  }
}
