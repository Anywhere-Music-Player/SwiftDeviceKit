// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  /// All iPhones
  public static var allPhones: [Device] {
    DeviceCatalog.all.filter { $0.family == .phone }.map(\.model)
  }

  /// All iPads
  public static var allPads: [Device] {
    DeviceCatalog.all.filter { $0.family == .pad }.map(\.model)
  }

  /// All Plus and Max-Sized Devices
  public static var allPlusSizedDevices: [Device] { DeviceCatalog.models(with: .plus) }

  /// All Pro Devices
  public static var allProDevices: [Device] { DeviceCatalog.models(with: .pro) }

  /// All mini Devices
  public static var allMiniDevices: [Device] { DeviceCatalog.models(with: .mini) }

  /// All X-Series Devices
  @available(*, deprecated, renamed: "allDevicesWithSensorHousing")
  public static var allXSeriesDevices: [Device] { DeviceCatalog.models(with: .xSeries) }

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

  /// All iPhone and iPad models that support at least one active eSIM, including dual eSIM models.
  ///
  /// Support varies by country, region, and carrier. For iPad, only Wi-Fi + Cellular variants
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

  /// All Devices with Touch ID or Face ID
  public static var allBiometricAuthenticationCapableDevices: [Device] {
    DeviceCatalog.all.filter {
      $0.capabilities.contains(.touchID) || $0.capabilities.contains(.faceID)
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

  /// All simulator iPad mini
  public static var allSimulatorMiniDevices: [Device] {
    return allMiniDevices.map(Device.simulator)
  }

  /// All simulator X series Devices
  @available(*, deprecated, renamed: "allSimulatorDevicesWithSensorHousing")
  public static var allSimulatorXSeriesDevices: [Device] {
    return allDevicesWithSensorHousing.map(Device.simulator)
  }

  /// All simulator Plus and Max-Sized Devices
  public static var allSimulatorPlusSizedDevices: [Device] {
    return allPlusSizedDevices.map(Device.simulator)
  }

  /// All simulator Pro Devices
  public static var allSimulatorProDevices: [Device] {
    return allProDevices.map(Device.simulator)
  }

  /// All simulator devices that feature a sensor housing in the screen
  public static var allSimulatorDevicesWithSensorHousing: [Device] {
    return allDevicesWithSensorHousing.map(Device.simulator)
  }

  /// All real devices (i.e. all devices except for all simulators)
  public static var allRealDevices: [Device] {
    return allPhones + allPads
  }

  /// All simulators
  public static var allSimulators: [Device] {
    return allRealDevices.map(Device.simulator)
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
  /// - returns: the underlying device If the `device` is a `simulator`,
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
    return isOneOf(Device.allTouchIDCapableDevices)
      || isOneOf(Device.allTouchIDCapableDevices.map(Device.simulator))
  }

  /// Returns whether or not the device has Face ID
  public var isFaceIDCapable: Bool {
    return isOneOf(Device.allFaceIDCapableDevices)
      || isOneOf(Device.allFaceIDCapableDevices.map(Device.simulator))
  }

  /// Returns whether or not the device has any biometric sensor (i.e. Touch ID or Face ID)
  public var hasBiometricSensor: Bool {
    return isTouchIDCapable || isFaceIDCapable
  }

  /// Returns whether or not the device has a sensor housing
  public var hasSensorHousing: Bool {
    return isOneOf(Device.allDevicesWithSensorHousing)
      || isOneOf(Device.allDevicesWithSensorHousing.map(Device.simulator))
  }

  /// Returns whether or not the device has a screen with rounded corners.
  public var hasRoundedDisplayCorners: Bool {
    return isOneOf(Device.allDevicesWithRoundedDisplayCorners)
      || isOneOf(Device.allDevicesWithRoundedDisplayCorners.map(Device.simulator))
  }

  /// Returns whether or not the device has the Dynamic Island.
  public var hasDynamicIsland: Bool {
    return isOneOf(Device.allDevicesWithDynamicIsland)
      || isOneOf(Device.allDevicesWithDynamicIsland.map(Device.simulator))
  }

  /// Returns whether or not the device has 3D Touch support.
  public var has3dTouchSupport: Bool {
    return isOneOf(Device.allDevicesWith3dTouchSupport)
      || isOneOf(Device.allDevicesWith3dTouchSupport.map(Device.simulator))
  }

  /// Returns whether or not the device supports wireless charging.
  public var supportsWirelessCharging: Bool {
    return isOneOf(Device.allDevicesWithWirelessChargingSupport)
      || isOneOf(Device.allDevicesWithWirelessChargingSupport.map(Device.simulator))
  }

  /// Returns whether or not the device has 5G support.
  public var has5gSupport: Bool {
    return isOneOf(Device.allDevicesWith5gSupport)
      || isOneOf(Device.allDevicesWith5gSupport.map(Device.simulator))
  }

  /// Returns whether the device model supports eSIM. Simulators use their simulated model.
  /// See `allDevicesWithEsimSupport` for regional and cellular-variant limitations.
  public var hasEsimSupport: Bool {
    return isOneOf(Device.allDevicesWithEsimSupport)
      || isOneOf(Device.allDevicesWithEsimSupport.map(Device.simulator))
  }

  /// Returns whether the device model supports two active eSIMs simultaneously.
  /// Simulators use their simulated model. See `allDevicesWithDualEsimSupport` for limitations.
  public var hasDualEsimSupport: Bool {
    return isOneOf(Device.allDevicesWithDualEsimSupport)
      || isOneOf(Device.allDevicesWithDualEsimSupport.map(Device.simulator))
  }

  /// Returns whether or not the device has a LiDAR sensor.
  public var hasLidarSensor: Bool {
    return isOneOf(Device.allDevicesWithALidarSensor)
      || isOneOf(Device.allDevicesWithALidarSensor.map(Device.simulator))
  }

  /// Returns whether or not the device has a USB-C power supply.
  public var hasUSBCConnectivity: Bool {
    return isOneOf(Device.allDevicesWithUSBCConnectivity)
      || isOneOf(Device.allDevicesWithUSBCConnectivity.map(Device.simulator))
  }

  /// Get the real device from a device.
  /// If the device is a an iPhone14Plus simulator this function returns .iPhone14Plus (the real device).
  /// If the parameter is a real device, this function returns just that passed parameter.
  ///
  /// - parameter device: A device.
  ///
  /// - returns: the underlying device If the `device` is a `simulator`,
  /// otherwise return the `device`.
  public static func realDevice(from device: Device) -> Device {
    if case .simulator(let model) = device {
      return model
    }
    return device
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

  /// Default panel's advertised diagonal in inches, or -1 if unavailable. Duo defaults to outer.
  public var diagonal: Double { screens.first?.diagonal ?? -1 }

  /// Default panel's catalog ratio. Duo defaults to outer, independently of fold state.
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
