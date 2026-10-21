// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhoneXSMax = DeviceDefinition(
    model: .iPhoneXSMax, family: .phone,
    name: "iPhone Xs Max",
    safeName: "iPhone XS Max",
    identifiers: ["iPhone11,4", "iPhone11,6"],
    cpu: .a12Bionic,
    capabilities: [
      .plus, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .force3DTouch,
      .wirelessCharging, .eSIM,
    ],
    cameras: [.wide, .telephoto],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.5, ppi: 458,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
