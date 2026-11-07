// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhone16e = DeviceDefinition(
    model: .iPhone16e, family: .phone,
    name: "iPhone 16e",
    identifiers: ["iPhone17,5"],
    cpu: .a18,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .fiveG, .eSIM,
      .dualESIM, .usbC, .actionButton,
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
