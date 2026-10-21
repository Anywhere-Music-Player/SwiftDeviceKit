// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone13ProMax = DeviceDefinition(
    model: .iPhone13ProMax, family: .phone,
    name: "iPhone 13 Pro Max",
    identifiers: ["iPhone14,3"],
    cpu: .a15Bionic,
    capabilities: [
      .plus, .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging,
      .fiveG, .eSIM, .dualESIM, .lidar,
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
