// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone17 = DeviceDefinition(
    model: .iPhone17, family: .phone,
    name: "iPhone 17",
    identifiers: ["iPhone18,3"],
    cpu: .a19,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland, .wirelessCharging,
      .fiveG, .eSIM, .dualESIM, .usbC,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.3, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
