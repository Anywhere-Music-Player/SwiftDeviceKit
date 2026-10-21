// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone13Pro = DeviceDefinition(
    model: .iPhone13Pro, family: .phone,
    name: "iPhone 13 Pro",
    identifiers: ["iPhone14,2"],
    cpu: .a15Bionic,
    capabilities: [
      .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG,
      .eSIM, .dualESIM, .lidar,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
