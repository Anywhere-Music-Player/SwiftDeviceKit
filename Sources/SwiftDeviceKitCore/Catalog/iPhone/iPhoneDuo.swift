// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

// Display and capability source: https://www.apple.com/iphone-duo/specs/
// Verified 2026-10-21. Outer panel is first and supplies scalar display metrics.

extension DeviceDefinition {
  static let iPhoneDuo = DeviceDefinition(
    model: .iPhoneDuo, family: .phone,
    name: "iPhone Duo",
    identifiers: ["iPhone19,4"],
    cpu: .a20Pro,
    capabilities: [
      .xSeries, .touchID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland, .wirelessCharging,
      .fiveG, .eSIM, .dualESIM, .usbC, .foldable,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: .firstGenerationUsbC,
    screens: [
      .init(
        role: .outer, diagonal: 5.4, ppi: 460,
        screenRatio: .init(width: 233, height: 339),
        resolution: .init(width: 1398, height: 2034)),
      .init(
        role: .inner, diagonal: 7.6, ppi: 430,
        screenRatio: .init(width: 313, height: 445),
        resolution: .init(width: 1878, height: 2670)),
    ]
  )
}
