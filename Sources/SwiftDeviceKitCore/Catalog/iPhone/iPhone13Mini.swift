// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone13Mini = DeviceDefinition(
    model: .iPhone13Mini, family: .phone,
    name: "iPhone 13 mini",
    identifiers: ["iPhone14,4"],
    cpu: .a15Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
      .dualESIM,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 5.4, ppi: 476,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
