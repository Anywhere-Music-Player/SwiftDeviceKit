// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

/// An immutable model record. Model-specific files extend this type with static definitions.
struct DeviceDefinition: Sendable {
  enum Family: Sendable { case phone, pad }

  enum Capability: Sendable, Hashable {
    case plus, pro, mini, xSeries, touchID, faceID, sensorHousing, roundedDisplayCorners,
      dynamicIsland, force3DTouch, wirelessCharging, fiveG, eSIM, dualESIM, lidar, usbC, foldable,
      actionButton, variableAperture
  }

  let model: Device
  let family: Family
  let name: String
  let safeName: String
  let identifiers: [String]
  let cpu: Device.CPU
  let capabilities: Set<Capability>
  let cameras: [Device.CameraType]
  let applePencilSupport: Device.ApplePencilSupport
  /// Default catalog panel first. This order does not reflect the current fold state.
  let screens: [Device.Screen]

  init(
    model: Device, family: Family, name: String, safeName: String? = nil,
    identifiers: [String], cpu: Device.CPU, capabilities: Set<Capability>,
    cameras: [Device.CameraType], applePencilSupport: Device.ApplePencilSupport,
    screens: [Device.Screen]
  ) {
    self.model = model
    self.family = family
    self.name = name
    self.safeName = safeName ?? name
    self.identifiers = identifiers
    self.cpu = cpu
    self.capabilities = capabilities
    self.cameras = cameras
    self.applePencilSupport = applePencilSupport
    self.screens = screens
  }
}
