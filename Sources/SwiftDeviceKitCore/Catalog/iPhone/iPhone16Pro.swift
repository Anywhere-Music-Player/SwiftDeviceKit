// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone16Pro = DeviceDefinition(
    model: .iPhone16Pro, family: .phone,
    name: "iPhone 16 Pro",
    identifiers: ["iPhone17,1"],
    cpu: .a18Pro,
    capabilities: [
      .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland,
      .wirelessCharging, .fiveG, .eSIM, .dualESIM, .lidar, .usbC,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.3, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
