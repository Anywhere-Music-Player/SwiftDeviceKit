// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone12Pro = DeviceDefinition(
    model: .iPhone12Pro, family: .phone,
    name: "iPhone 12 Pro",
    identifiers: ["iPhone13,3"],
    cpu: .a14Bionic,
    capabilities: [
      .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG,
      .eSIM, .lidar,
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
