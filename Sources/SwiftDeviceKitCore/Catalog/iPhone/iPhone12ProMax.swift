// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone12ProMax = DeviceDefinition(
    model: .iPhone12ProMax, family: .phone,
    name: "iPhone 12 Pro Max",
    identifiers: ["iPhone13,4"],
    cpu: .a14Bionic,
    capabilities: [
      .plus, .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging,
      .fiveG, .eSIM, .lidar,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.7, ppi: 458,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
