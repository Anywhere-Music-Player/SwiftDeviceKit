// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhoneXR = DeviceDefinition(
    model: .iPhoneXR, family: .phone,
    name: "iPhone Xʀ",
    safeName: "iPhone XR",
    identifiers: ["iPhone11,8"],
    cpu: .a12Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .wirelessCharging, .eSIM,
    ],
    cameras: [.wide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.1, ppi: 326,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
