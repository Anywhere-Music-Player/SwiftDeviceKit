// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone15 = DeviceDefinition(
    model: .iPhone15, family: .phone,
    name: "iPhone 15",
    identifiers: ["iPhone15,4"],
    cpu: .a16Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland, .wirelessCharging,
      .fiveG, .eSIM, .dualESIM, .usbC,
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
