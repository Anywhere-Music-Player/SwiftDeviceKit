// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone16 = DeviceDefinition(
    model: .iPhone16, family: .phone,
    name: "iPhone 16",
    identifiers: ["iPhone17,3"],
    cpu: .a18,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland, .wirelessCharging,
      .fiveG, .eSIM, .dualESIM, .usbC, .actionButton,
    ],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
