// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  /// Product family from the catalog or a host explicitly identified by the OS.
  public enum Family: Sendable { case phone, pad, watch, tv, mac, vision }
  public var family: Family? {
    let model = realDevice
    if case .unidentifiedVision = model { return .vision }
    return model.definition?.family
  }

  public static var allWatches: [Device] { DeviceCatalog.models(in: .watch) }
  public static var allTVs: [Device] { DeviceCatalog.models(in: .tv) }
  public static var allMacs: [Device] { DeviceCatalog.models(in: .mac) }
  public static var allVisions: [Device] { DeviceCatalog.models(in: .vision) }

  public static var allSimulatorWatches: [Device] { allWatches.map(Device.simulator) }
  public static var allSimulatorTVs: [Device] { allTVs.map(Device.simulator) }
  public static var allSimulatorVisions: [Device] { allVisions.map(Device.simulator) }

  /// Apple removed Force Touch before the oldest watch supported by watchOS 11.
  public static var allWatchesWithForceTouchSupport: [Device] { [] }
  public var hasForceTouchSupport: Bool { false }

  public var isWatch: Bool { family == .watch }
  public var isTV: Bool { family == .tv }
  public var isMac: Bool { family == .mac }
  public var isVision: Bool { family == .vision }

  public var isOpticIDCapable: Bool { definition?.capabilities.contains(.opticID) == true }

  /// All iPhones
  public static var allPhones: [Device] {
    DeviceCatalog.models(in: .phone)
  }

  /// All iPads
  public static var allPads: [Device] {
    DeviceCatalog.models(in: .pad)
  }

  /// All Plus and Max-Sized Devices
  public static var allPlusSizedDevices: [Device] { DeviceCatalog.models(with: .plus) }

  /// All Pro Devices
  public static var allProDevices: [Device] { DeviceCatalog.models(with: .pro) }

  /// All mini Devices
  public static var allMiniDevices: [Device] { DeviceCatalog.models(with: .mini) }

  /// All X-Series Devices
  @available(*, deprecated, renamed: "allPhonesWithSensorHousing")
  public static var allXSeriesDevices: [Device] { allPhonesWithSensorHousing }

  /// iPhones with a sensor housing, in catalog order.
  public static var allPhonesWithSensorHousing: [Device] { DeviceCatalog.models(with: .xSeries) }

  /// All Touch ID Capable Devices
  public static var allTouchIDCapableDevices: [Device] { DeviceCatalog.models(with: .touchID) }

  /// All Face ID Capable Devices
  public static var allFaceIDCapableDevices: [Device] { DeviceCatalog.models(with: .faceID) }

  /// All devices that feature a sensor housing in the screen
  public static var allDevicesWithSensorHousing: [Device] {
    DeviceCatalog.models(with: .sensorHousing)
  }

  /// All devices that feature a screen with rounded corners.
  public static var allDevicesWithRoundedDisplayCorners: [Device] {
    DeviceCatalog.models(with: .roundedDisplayCorners)
  }

  /// All devices that have the Dynamic Island.
  public static var allDevicesWithDynamicIsland: [Device] {
    DeviceCatalog.models(with: .dynamicIsland)
  }

  /// Catalog models with a physical, customizable Action button.
  public static var allDevicesWithActionButton: [Device] {
    DeviceCatalog.models(with: .actionButton)
  }

  /// All devices that have 3D Touch support.
  public static var allDevicesWith3dTouchSupport: [Device] {
    DeviceCatalog.models(with: .force3DTouch)
  }

  /// All devices that support wireless charging.
  public static var allDevicesWithWirelessChargingSupport: [Device] {
    DeviceCatalog.models(with: .wirelessCharging)
  }

  /// All devices that support 5G.
  public static var allDevicesWith5gSupport: [Device] { DeviceCatalog.models(with: .fiveG) }

  /// All models that support at least one active eSIM, including dual eSIM models.
  ///
  /// Support varies by country, region, and carrier. For iPad and Apple Watch, only cellular variants
  /// support eSIM. Device cases do not distinguish these variants, so membership describes
  /// model capabilities and does not guarantee eSIM availability on a particular device.
  /// See https://support.apple.com/en-us/109317 and https://support.apple.com/en-us/119592.
  public static var allDevicesWithEsimSupport: [Device] { DeviceCatalog.models(with: .eSIM) }

  /// All iPhone models that support two active eSIMs simultaneously.
  /// Support varies by country, region, and carrier; model membership does not guarantee
  /// eSIM availability on a particular device. These models also appear in `allDevicesWithEsimSupport`.
  public static var allDevicesWithDualEsimSupport: [Device] {
    DeviceCatalog.models(with: .dualESIM)
  }

  /// All devices that have a LiDAR sensor.
  public static var allDevicesWithALidarSensor: [Device] { DeviceCatalog.models(with: .lidar) }

  /// All devices that have a USB-C connectivity.
  public static var allDevicesWithUSBCConnectivity: [Device] { DeviceCatalog.models(with: .usbC) }

  /// All devices with built-in biometric authentication
  public static var allBiometricAuthenticationCapableDevices: [Device] {
    DeviceCatalog.all.filter {
      $0.capabilities.contains(.touchID) || $0.capabilities.contains(.faceID) || $0.capabilities.contains(.opticID)
    }.map(\.model)
  }

  /// All Apple Pencil Capable Devices
  public static var allApplePencilCapableDevices: [Device] {
    DeviceCatalog.all.filter { !$0.applePencilSupport.isEmpty }.map(\.model)
  }

  /// All devices that feature a camera
  public static var allDevicesWithCamera: [Device] {
    DeviceCatalog.all.filter { !$0.cameras.isEmpty }.map(\.model)
  }

  /// All devices that feature a wide camera
  public static var allDevicesWithWideCamera: [Device] {
    DeviceCatalog.all.filter { $0.cameras.contains(.wide) }.map(\.model)
  }

  /// All devices that feature a telephoto camera
  public static var allDevicesWithTelephotoCamera: [Device] {
    DeviceCatalog.all.filter { $0.cameras.contains(.telephoto) }.map(\.model)
  }

  /// All devices that feature an ultra wide camera
  public static var allDevicesWithUltraWideCamera: [Device] {
    DeviceCatalog.all.filter { $0.cameras.contains(.ultraWide) }.map(\.model)
  }

  /// All simulator iPhones
  public static var allSimulatorPhones: [Device] {
    return allPhones.map(Device.simulator)
  }

  /// All simulator iPads
  public static var allSimulatorPads: [Device] {
    return allPads.map(Device.simulator)
  }

  /// All simulatable mini models
  public static var allSimulatorMiniDevices: [Device] {
    simulators(for: allMiniDevices)
  }

  /// All simulator X series Devices
  @available(*, deprecated, renamed: "allSimulatorDevicesWithSensorHousing")
  public static var allSimulatorXSeriesDevices: [Device] {
    allSimulatorDevicesWithSensorHousing
  }

  /// All simulator Plus and Max-Sized Devices
  public static var allSimulatorPlusSizedDevices: [Device] {
    simulators(for: allPlusSizedDevices)
  }

  /// All simulator Pro Devices
  public static var allSimulatorProDevices: [Device] {
    simulators(for: allProDevices)
  }

  /// All simulator devices that feature a sensor housing in the screen
  public static var allSimulatorDevicesWithSensorHousing: [Device] {
    simulators(for: allDevicesWithSensorHousing)
  }

  /// All real devices (i.e. all devices except for all simulators)
  public static var allRealDevices: [Device] {
    DeviceCatalog.all.map(\.model)
  }

  /// All simulators
  public static var allSimulators: [Device] {
    simulators(for: allRealDevices)
  }

  private static func simulators(for models: [Device]) -> [Device] {
    models.filter { $0.family != .mac }.map(Device.simulator)
  }

  /// All devices that feature a normal camera
  @available(*, deprecated, renamed: "allDevicesWithWideCamera")
  public static var allDevicesWithNormalCamera: [Device] {
    return Device.allDevicesWithWideCamera
  }

  /// Get the real device from a device.
  /// If the device is a an iPhone14Plus simulator this function returns .iPhone14Plus (the real device).
  /// If the parameter is a real device, this function returns just that passed parameter.
  ///
  /// - parameter device: A device.
  ///
  /// - returns: the fully unwrapped device if `device` is a `simulator`,
  /// otherwise return the `device`.
  public var realDevice: Device {
    return Device.realDevice(from: self)
  }

  /// Returns whether the device is a simulator, including unknown models.
  /// Useful when there is a need to check and skip running a portion of code (location request or others)
  public var isSimulator: Bool {
    if case .simulator = self { return true }
    return false
  }

  /// Returns whether or not the device has Touch ID
  public var isTouchIDCapable: Bool {
    return definition?.capabilities.contains(.touchID) ?? false
  }

  /// Returns whether or not the device has Face ID
  public var isFaceIDCapable: Bool {
    return definition?.capabilities.contains(.faceID) ?? false
  }

  /// Returns whether or not the device has any biometric sensor (i.e. Touch ID or Face ID)
  public var hasBiometricSensor: Bool {
    return isTouchIDCapable || isFaceIDCapable || isOpticIDCapable
  }

  /// Returns whether or not the device has a sensor housing
  public var hasSensorHousing: Bool {
    return definition?.capabilities.contains(.sensorHousing) ?? false
  }

  /// Returns whether or not the device has a screen with rounded corners.
  public var hasRoundedDisplayCorners: Bool {
    return definition?.capabilities.contains(.roundedDisplayCorners) ?? false
  }

  /// Returns whether or not the device has the Dynamic Island.
  public var hasDynamicIsland: Bool {
    return definition?.capabilities.contains(.dynamicIsland) ?? false
  }

  /// Whether the model has an Action button. Simulators report their model's capability.
  public var hasActionButton: Bool {
    definition?.capabilities.contains(.actionButton) ?? false
  }

  /// Returns whether or not the device has 3D Touch support.
  public var has3dTouchSupport: Bool {
    return definition?.capabilities.contains(.force3DTouch) ?? false
  }

  /// Returns whether or not the device supports wireless charging.
  public var supportsWirelessCharging: Bool {
    return definition?.capabilities.contains(.wirelessCharging) ?? false
  }

  /// Returns whether or not the device has 5G support.
  public var has5gSupport: Bool {
    return definition?.capabilities.contains(.fiveG) ?? false
  }

  /// Returns whether the device model supports eSIM. Simulators use their simulated model.
  /// See `allDevicesWithEsimSupport` for regional and cellular-variant limitations.
  public var hasEsimSupport: Bool {
    return definition?.capabilities.contains(.eSIM) ?? false
  }

  /// Returns whether the device model supports two active eSIMs simultaneously.
  /// Simulators use their simulated model. See `allDevicesWithDualEsimSupport` for limitations.
  public var hasDualEsimSupport: Bool {
    return definition?.capabilities.contains(.dualESIM) ?? false
  }

  /// Returns whether or not the device has a LiDAR sensor.
  public var hasLidarSensor: Bool {
    return definition?.capabilities.contains(.lidar) ?? false
  }

  /// Whether the hardware includes USB-C. Apple TV HD uses it for service and Vision Pro for battery charging.
  public var hasUSBCConnectivity: Bool {
    return definition?.capabilities.contains(.usbC) ?? false
  }

  /// Get the real device from a device.
  /// If the device is a an iPhone14Plus simulator this function returns .iPhone14Plus (the real device).
  /// If the parameter is a real device, this function returns just that passed parameter.
  ///
  /// - parameter device: A device.
  ///
  /// - returns: the fully unwrapped device if `device` is a `simulator`,
  /// otherwise return the `device`.
  public static func realDevice(from device: Device) -> Device {
    var model = device
    while case .simulator(let wrapped) = model {
      model = wrapped
    }
    return model
  }

  /**
   Tests membership in a catalog group, avoiding an explicit switch over individual models.

   ```
   let device = Device.current.realDevice
   if device.isOneOf(Device.allPhones) {
     callMethodOnIPhones()
   } else if device.isOneOf(Device.allPads) {
     callMethodOnIPads()
   }
   ```

   - parameter devices: An array of devices.

   - returns: Returns whether the current device is one of the passed in ones.
   */
  public func isOneOf(_ devices: [Device]) -> Bool {
    return devices.contains(self)
  }

  /// Whether the catalog model has a foldable display, including simulator wrappers.
  public var isFoldable: Bool { definition?.capabilities.contains(.foldable) ?? false }

  /// Default panel's diagonal in inches, or -1 if unavailable. Duo defaults to outer.
  public var diagonal: Double { screens.first?.diagonal ?? -1 }

  /// Default panel's portrait width-to-height ratio. Duo defaults to outer, independently of fold state.
  public var screenRatio: (width: Double, height: Double) {
    if let screen = screens.first { return (screen.screenRatio.width, screen.screenRatio.height) }
    return (-1, -1)
  }

  /// Default panel's PPI. Duo defaults to outer; unknown models return nil.
  public var ppi: Int? {
    screens.first?.ppi
  }

  /// Returns the cpu (SoC) that the device uses
  public var cpu: CPU { definition?.cpu ?? .unknown }
  /// Returns an array of the types of cameras the device has
  public var cameras: [CameraType] { definition?.cameras ?? [] }
  /// Returns supported version of the Apple Pencil
  public var applePencilSupport: ApplePencilSupport { definition?.applePencilSupport ?? [] }

}
