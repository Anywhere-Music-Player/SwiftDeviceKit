// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone11ProMax = DeviceDefinition(
    model: .iPhone11ProMax, family: .phone,
    name: "iPhone 11 Pro Max",
    identifiers: ["iPhone12,5"],
    cpu: .a13Bionic,
    capabilities: [
      .plus, .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging,
      .eSIM,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.5, ppi: 458,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
