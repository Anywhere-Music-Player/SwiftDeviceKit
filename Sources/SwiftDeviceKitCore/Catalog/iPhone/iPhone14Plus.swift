// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone14Plus = DeviceDefinition(
    model: .iPhone14Plus, family: .phone,
    name: "iPhone 14 Plus",
    identifiers: ["iPhone14,8"],
    cpu: .a15Bionic,
    capabilities: [
      .plus, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG,
      .eSIM, .dualESIM,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.7, ppi: 458,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
