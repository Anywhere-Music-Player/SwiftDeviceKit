// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone12Mini = DeviceDefinition(
    model: .iPhone12Mini, family: .phone,
    name: "iPhone 12 mini",
    identifiers: ["iPhone13,1"],
    cpu: .a14Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
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
