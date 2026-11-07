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
  ]

  static let byIdentifier: [String: Device] = Dictionary(
    uniqueKeysWithValues: all.flatMap { definition in
      definition.identifiers.map { ($0, definition.model) }
    }
  )

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
    case .simulator(let model): return model.definition
    case .unknown: return nil
    }
  }
}
