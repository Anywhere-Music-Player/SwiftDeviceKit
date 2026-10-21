// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhoneXS = DeviceDefinition(
    model: .iPhoneXS, family: .phone,
    name: "iPhone Xs",
    safeName: "iPhone XS",
    identifiers: ["iPhone11,2"],
    cpu: .a12Bionic,
    capabilities: [
      .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .force3DTouch, .wirelessCharging,
      .eSIM,
    ],
    cameras: [.wide, .telephoto],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 5.8, ppi: 458,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
