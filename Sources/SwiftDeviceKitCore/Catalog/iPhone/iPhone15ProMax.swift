// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone15ProMax = DeviceDefinition(
    model: .iPhone15ProMax, family: .phone,
    name: "iPhone 15 Pro Max",
    identifiers: ["iPhone16,2"],
    cpu: .a17Pro,
    capabilities: [
      .plus, .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland,
      .wirelessCharging, .fiveG, .eSIM, .dualESIM, .lidar, .usbC,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.7, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
