// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone11 = DeviceDefinition(
    model: .iPhone11, family: .phone,
    name: "iPhone 11",
    identifiers: ["iPhone12,1"],
    cpu: .a13Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .eSIM,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 326,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
