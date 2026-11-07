// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

/// Explicit registration keeps catalog order stable without runtime reflection or build tooling.
enum DeviceCatalog {
  static let all: [DeviceDefinition] = [
    .iPhoneXS,
    .iPhoneXSMax,
    .iPhoneXR,
    .iPhone11,
    .iPhone11Pro,
    .iPhone11ProMax,
    .iPhoneSE2,
    .iPhone12,
    .iPhone12Mini,
    .iPhone12Pro,
    .iPhone12ProMax,
    .iPhone13,
    .iPhone13Mini,
    .iPhone13Pro,
    .iPhone13ProMax,
    .iPhoneSE3,
    .iPhone14,
    .iPhone14Plus,
    .iPhone14Pro,
    .iPhone14ProMax,
    .iPhone15,
    .iPhone15Plus,
    .iPhone15Pro,
    .iPhone15ProMax,
    .iPhone16,
    .iPhone16Plus,
    .iPhone16Pro,
    .iPhone16ProMax,
    .iPhone16e,
    .iPhone17,
    .iPhone17Pro,
    .iPhone17ProMax,
    .iPhoneAir,
    .iPhone17e,
    .iPhone18Pro,
    .iPhone18ProMax,
    .iPhoneDuo,
    .iPadAir3,
    .iPad7,
    .iPad8,
    .iPad9,
    .iPad10,
    .iPadA16,
    .iPadAir4,
    .iPadAir5,
    .iPadAir11M2,
    .iPadAir13M2,
    .iPadAir11M3,
    .iPadAir13M3,
    .iPadAir11M4,
    .iPadAir13M4,
    .iPadMini5,
    .iPadMini6,
    .iPadMiniA17Pro,
    .iPadMiniA20Pro,
    .iPadPro11Inch,
    .iPadPro12Inch3,
    .iPadPro11Inch2,
    .iPadPro12Inch4,
    .iPadPro11Inch3,
    .iPadPro12Inch5,
    .iPadPro11Inch4,
    .iPadPro12Inch6,
    .iPadPro11M4,
    .iPadPro13M4,
    .iPadPro11M5,
    .iPadPro13M5,
    .appleWatchSeries6_40mm,
    .appleWatchSeries6_44mm,
    .appleWatchSeries7_41mm,
    .appleWatchSeries7_45mm,
    .appleWatchSeries8_41mm,
    .appleWatchSeries8_45mm,
    .appleWatchSE2_40mm,
    .appleWatchSE2_44mm,
    .appleWatchUltra,
    .appleWatchSeries9_41mm,
    .appleWatchSeries9_45mm,
    .appleWatchUltra2,
    .appleWatchSE3_40mm,
    .appleWatchSE3_44mm,
    .appleWatchSeries10_42mm,
    .appleWatchSeries10_46mm,
    .appleWatchUltra3,
    .appleWatchSeries11_42mm,
    .appleWatchSeries11_46mm,
    .appleWatchSeries12_42mm,
    .appleWatchSeries12_46mm,
    .appleWatchUltra4,
    .appleTVHD,
    .appleTV4K,
    .appleTV4K2,
    .appleTV4K3,
    .appleTV4K4,
    .appleVisionProM2,
    .appleVisionProM5,
    .macBookPro152018To2019,
    .macBookPro152018To2019Vega,
    .macBookPro132018To2019FourPorts,
    .macBookPro132019TwoPorts,
    .macBookPro162019,
    .macBookPro132020FourPorts,
    .macBookPro132020TwoPorts,
    .macBookPro13M1,
    .macBookPro13M2,
    .macBookPro14M1Pro,
    .macBookPro14M1Max,
    .macBookPro16M1Pro,
    .macBookPro16M1Max,
    .macBookPro14M2Pro,
    .macBookPro14M2Max,
    .macBookPro16M2Pro,
    .macBookPro16M2Max,
    .macBookPro14M3,
    .macBookPro14M3Pro,
    .macBookPro14M3Max,
    .macBookPro16M3Pro,
    .macBookPro16M3Max,
    .macBookPro14M4,
    .macBookPro14M4Pro,
    .macBookPro14M4Max,
    .macBookPro16M4Pro,
    .macBookPro16M4Max,
    .macBookPro14M5,
    .macBookPro14M5Pro,
    .macBookPro14M5Max,
    .macBookPro16M5Pro,
    .macBookPro16M5Max,
    .macBookPro14M5ProPROLED,
    .macBookPro14M5MaxPROLED,
    .macBookPro16M5ProPROLED,
    .macBookPro16M5MaxPROLED,
    .macBookPro14M6,
    .macBookAir13Intel2020,
    .macBookAir13M1,
    .macBookAir13M2,
    .macBookAir15M2,
    .macBookAir13M3,
    .macBookAir15M3,
    .macBookAir13M4,
    .macBookAir15M4,
    .macBookAir13M5,
    .macBookAir15M5,
    .macBookNeo,
    .macMini2018,
    .macMiniM1,
    .macMiniM2,
    .macMiniM2Pro,
    .macMiniM4,
    .macMiniM4Pro,
    .macMiniM5Pro,
    .macMiniM6,
    .macStudioM1Max,
    .macStudioM1Ultra,
    .macStudioM2Max,
    .macStudioM2Ultra,
    .macStudioM3Ultra,
    .macStudioM4Max,
    .macStudioM5Max,
    .macStudioM5Ultra,
    .macPro2019,
    .macProM2Ultra,
    .iMacPro,
    .iMac27Intel2019,
    .iMac21Intel2019,
    .iMac27Intel2020,
    .iMac24M1FourPorts,
    .iMac24M1TwoPorts,
    .iMac24M3FourPorts,
    .iMac24M3TwoPorts,
    .iMac24M4FourPorts,
    .iMac24M4TwoPorts,
    .iMac24M6,
  ]

  static let byIdentifier: [String: Device] = Dictionary(
    uniqueKeysWithValues: all.flatMap { definition in
      definition.identifiers.map { ($0, definition.model) }
    }
  )

  static func models(in family: Device.Family) -> [Device] {
    all.filter { $0.family == family }.map(\.model)
  }

  static func models(with capability: DeviceDefinition.Capability) -> [Device] {
    all.filter { $0.capabilities.contains(capability) }.map(\.model)
  }
}

extension Device {
  /// Exhaustive mapping makes an unhandled new enum case a compiler error.
  var definition: DeviceDefinition? {
    switch self {
    case .iPhoneXS: return .iPhoneXS
    case .iPhoneXSMax: return .iPhoneXSMax
    case .iPhoneXR: return .iPhoneXR
    case .iPhone11: return .iPhone11
    case .iPhone11Pro: return .iPhone11Pro
    case .iPhone11ProMax: return .iPhone11ProMax
    case .iPhoneSE2: return .iPhoneSE2
    case .iPhone12: return .iPhone12
    case .iPhone12Mini: return .iPhone12Mini
    case .iPhone12Pro: return .iPhone12Pro
    case .iPhone12ProMax: return .iPhone12ProMax
    case .iPhone13: return .iPhone13
    case .iPhone13Mini: return .iPhone13Mini
    case .iPhone13Pro: return .iPhone13Pro
    case .iPhone13ProMax: return .iPhone13ProMax
    case .iPhoneSE3: return .iPhoneSE3
    case .iPhone14: return .iPhone14
    case .iPhone14Plus: return .iPhone14Plus
    case .iPhone14Pro: return .iPhone14Pro
    case .iPhone14ProMax: return .iPhone14ProMax
    case .iPhone15: return .iPhone15
    case .iPhone15Plus: return .iPhone15Plus
    case .iPhone15Pro: return .iPhone15Pro
    case .iPhone15ProMax: return .iPhone15ProMax
    case .iPhone16: return .iPhone16
    case .iPhone16Plus: return .iPhone16Plus
    case .iPhone16Pro: return .iPhone16Pro
    case .iPhone16ProMax: return .iPhone16ProMax
    case .iPhone16e: return .iPhone16e
    case .iPhone17: return .iPhone17
    case .iPhone17Pro: return .iPhone17Pro
    case .iPhone17ProMax: return .iPhone17ProMax
    case .iPhoneAir: return .iPhoneAir
    case .iPhone17e: return .iPhone17e
    case .iPhone18Pro: return .iPhone18Pro
    case .iPhone18ProMax: return .iPhone18ProMax
    case .iPhoneDuo: return .iPhoneDuo
    case .iPadAir3: return .iPadAir3
    case .iPad7: return .iPad7
    case .iPad8: return .iPad8
    case .iPad9: return .iPad9
    case .iPad10: return .iPad10
    case .iPadA16: return .iPadA16
    case .iPadAir4: return .iPadAir4
    case .iPadAir5: return .iPadAir5
    case .iPadAir11M2: return .iPadAir11M2
    case .iPadAir13M2: return .iPadAir13M2
    case .iPadAir11M3: return .iPadAir11M3
    case .iPadAir13M3: return .iPadAir13M3
    case .iPadAir11M4: return .iPadAir11M4
    case .iPadAir13M4: return .iPadAir13M4
    case .iPadMini5: return .iPadMini5
    case .iPadMini6: return .iPadMini6
    case .iPadMiniA17Pro: return .iPadMiniA17Pro
    case .iPadMiniA20Pro: return .iPadMiniA20Pro
    case .iPadPro11Inch: return .iPadPro11Inch
    case .iPadPro12Inch3: return .iPadPro12Inch3
    case .iPadPro11Inch2: return .iPadPro11Inch2
    case .iPadPro12Inch4: return .iPadPro12Inch4
    case .iPadPro11Inch3: return .iPadPro11Inch3
    case .iPadPro12Inch5: return .iPadPro12Inch5
    case .iPadPro11Inch4: return .iPadPro11Inch4
    case .iPadPro12Inch6: return .iPadPro12Inch6
    case .iPadPro11M4: return .iPadPro11M4
    case .iPadPro13M4: return .iPadPro13M4
    case .iPadPro11M5: return .iPadPro11M5
    case .iPadPro13M5: return .iPadPro13M5
    case .appleWatchSeries6_40mm: return .appleWatchSeries6_40mm
    case .appleWatchSeries6_44mm: return .appleWatchSeries6_44mm
    case .appleWatchSeries7_41mm: return .appleWatchSeries7_41mm
    case .appleWatchSeries7_45mm: return .appleWatchSeries7_45mm
    case .appleWatchSeries8_41mm: return .appleWatchSeries8_41mm
    case .appleWatchSeries8_45mm: return .appleWatchSeries8_45mm
    case .appleWatchSE2_40mm: return .appleWatchSE2_40mm
    case .appleWatchSE2_44mm: return .appleWatchSE2_44mm
    case .appleWatchUltra: return .appleWatchUltra
    case .appleWatchSeries9_41mm: return .appleWatchSeries9_41mm
    case .appleWatchSeries9_45mm: return .appleWatchSeries9_45mm
    case .appleWatchUltra2: return .appleWatchUltra2
    case .appleWatchSE3_40mm: return .appleWatchSE3_40mm
    case .appleWatchSE3_44mm: return .appleWatchSE3_44mm
    case .appleWatchSeries10_42mm: return .appleWatchSeries10_42mm
    case .appleWatchSeries10_46mm: return .appleWatchSeries10_46mm
    case .appleWatchUltra3: return .appleWatchUltra3
    case .appleWatchSeries11_42mm: return .appleWatchSeries11_42mm
    case .appleWatchSeries11_46mm: return .appleWatchSeries11_46mm
    case .appleWatchSeries12_42mm: return .appleWatchSeries12_42mm
    case .appleWatchSeries12_46mm: return .appleWatchSeries12_46mm
    case .appleWatchUltra4: return .appleWatchUltra4
    case .appleTVHD: return .appleTVHD
    case .appleTV4K: return .appleTV4K
    case .appleTV4K2: return .appleTV4K2
    case .appleTV4K3: return .appleTV4K3
    case .appleTV4K4: return .appleTV4K4
    case .appleVisionProM2: return .appleVisionProM2
    case .appleVisionProM5: return .appleVisionProM5
    case .macBookPro152018To2019: return .macBookPro152018To2019
    case .macBookPro152018To2019Vega: return .macBookPro152018To2019Vega
    case .macBookPro132018To2019FourPorts: return .macBookPro132018To2019FourPorts
    case .macBookPro132019TwoPorts: return .macBookPro132019TwoPorts
    case .macBookPro162019: return .macBookPro162019
    case .macBookPro132020FourPorts: return .macBookPro132020FourPorts
    case .macBookPro132020TwoPorts: return .macBookPro132020TwoPorts
    case .macBookPro13M1: return .macBookPro13M1
    case .macBookPro13M2: return .macBookPro13M2
    case .macBookPro14M1Pro: return .macBookPro14M1Pro
    case .macBookPro14M1Max: return .macBookPro14M1Max
    case .macBookPro16M1Pro: return .macBookPro16M1Pro
    case .macBookPro16M1Max: return .macBookPro16M1Max
    case .macBookPro14M2Pro: return .macBookPro14M2Pro
    case .macBookPro14M2Max: return .macBookPro14M2Max
    case .macBookPro16M2Pro: return .macBookPro16M2Pro
    case .macBookPro16M2Max: return .macBookPro16M2Max
    case .macBookPro14M3: return .macBookPro14M3
    case .macBookPro14M3Pro: return .macBookPro14M3Pro
    case .macBookPro14M3Max: return .macBookPro14M3Max
    case .macBookPro16M3Pro: return .macBookPro16M3Pro
    case .macBookPro16M3Max: return .macBookPro16M3Max
    case .macBookPro14M4: return .macBookPro14M4
    case .macBookPro14M4Pro: return .macBookPro14M4Pro
    case .macBookPro14M4Max: return .macBookPro14M4Max
    case .macBookPro16M4Pro: return .macBookPro16M4Pro
    case .macBookPro16M4Max: return .macBookPro16M4Max
    case .macBookPro14M5: return .macBookPro14M5
    case .macBookPro14M5Pro: return .macBookPro14M5Pro
    case .macBookPro14M5Max: return .macBookPro14M5Max
    case .macBookPro16M5Pro: return .macBookPro16M5Pro
    case .macBookPro16M5Max: return .macBookPro16M5Max
    case .macBookPro14M5ProPROLED: return .macBookPro14M5ProPROLED
    case .macBookPro14M5MaxPROLED: return .macBookPro14M5MaxPROLED
    case .macBookPro16M5ProPROLED: return .macBookPro16M5ProPROLED
    case .macBookPro16M5MaxPROLED: return .macBookPro16M5MaxPROLED
    case .macBookPro14M6: return .macBookPro14M6
    case .macBookAir13Intel2020: return .macBookAir13Intel2020
    case .macBookAir13M1: return .macBookAir13M1
    case .macBookAir13M2: return .macBookAir13M2
    case .macBookAir15M2: return .macBookAir15M2
    case .macBookAir13M3: return .macBookAir13M3
    case .macBookAir15M3: return .macBookAir15M3
    case .macBookAir13M4: return .macBookAir13M4
    case .macBookAir15M4: return .macBookAir15M4
    case .macBookAir13M5: return .macBookAir13M5
    case .macBookAir15M5: return .macBookAir15M5
    case .macBookNeo: return .macBookNeo
    case .macMini2018: return .macMini2018
    case .macMiniM1: return .macMiniM1
    case .macMiniM2: return .macMiniM2
    case .macMiniM2Pro: return .macMiniM2Pro
    case .macMiniM4: return .macMiniM4
    case .macMiniM4Pro: return .macMiniM4Pro
    case .macMiniM5Pro: return .macMiniM5Pro
    case .macMiniM6: return .macMiniM6
    case .macStudioM1Max: return .macStudioM1Max
    case .macStudioM1Ultra: return .macStudioM1Ultra
    case .macStudioM2Max: return .macStudioM2Max
    case .macStudioM2Ultra: return .macStudioM2Ultra
    case .macStudioM3Ultra: return .macStudioM3Ultra
    case .macStudioM4Max: return .macStudioM4Max
    case .macStudioM5Max: return .macStudioM5Max
    case .macStudioM5Ultra: return .macStudioM5Ultra
    case .macPro2019: return .macPro2019
    case .macProM2Ultra: return .macProM2Ultra
    case .iMacPro: return .iMacPro
    case .iMac27Intel2019: return .iMac27Intel2019
    case .iMac21Intel2019: return .iMac21Intel2019
    case .iMac27Intel2020: return .iMac27Intel2020
    case .iMac24M1FourPorts: return .iMac24M1FourPorts
    case .iMac24M1TwoPorts: return .iMac24M1TwoPorts
    case .iMac24M3FourPorts: return .iMac24M3FourPorts
    case .iMac24M3TwoPorts: return .iMac24M3TwoPorts
    case .iMac24M4FourPorts: return .iMac24M4FourPorts
    case .iMac24M4TwoPorts: return .iMac24M4TwoPorts
    case .iMac24M6: return .iMac24M6
    case .simulator(let model): return model.definition
    case .unknown, .unidentifiedVision: return nil
    }
  }
}
