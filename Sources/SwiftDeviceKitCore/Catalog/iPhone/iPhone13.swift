// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone13 = DeviceDefinition(
    model: .iPhone13, family: .phone,
    name: "iPhone 13",
    identifiers: ["iPhone14,5"],
    cpu: .a15Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
      .dualESIM,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
