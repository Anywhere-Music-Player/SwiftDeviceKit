// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11Inch = DeviceDefinition(
    model: .iPadPro11Inch, family: .pad,
    name: "iPad Pro (11-inch)",
    identifiers: ["iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"],
    cpu: .a12XBionic,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 11, ppi: 264,
        screenRatio: .init(width: 139, height: 199), resolution: nil)
    ]
  )
}
