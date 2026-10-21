// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone12 = DeviceDefinition(
    model: .iPhone12, family: .phone,
    name: "iPhone 12",
    identifiers: ["iPhone13,2"],
    cpu: .a14Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
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
