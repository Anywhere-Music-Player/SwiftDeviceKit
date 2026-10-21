// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone17e = DeviceDefinition(
    model: .iPhone17e, family: .phone,
    name: "iPhone 17e",
    identifiers: ["iPhone18,5"],
    cpu: .a19,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
      .dualESIM, .usbC,
    ],
    cameras: [.wide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
