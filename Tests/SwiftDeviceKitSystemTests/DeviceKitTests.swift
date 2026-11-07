// ===----------------------------------------------------------------------=== //
//
// This source file is part of the DeviceKit open source project
//
// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
//
// License: https://github.com/dennisweissmann/DeviceKit/blob/master/LICENSE
// Contributors: https://github.com/dennisweissmann/DeviceKit#contributors
//
// ===----------------------------------------------------------------------=== //

import XCTest

@testable import SwiftDeviceKitSystem

@MainActor
final class DeviceKitTests: XCTestCase {

  let device = Device.current

  func testSeptember2026Devices() {
    struct ExpectedDevice {
      let model: Device
      let identifiers: [String]
      let diagonal: Double
      let ratio: (Double, Double)
      let ppi: Int
    }
    let models: [ExpectedDevice] = [
      ExpectedDevice(
        model: .iPhone18Pro, identifiers: ["iPhone19,2"], diagonal: 6.3, ratio: (9, 19.5), ppi: 460),
      ExpectedDevice(
        model: .iPhone18ProMax, identifiers: ["iPhone19,3", "iPhone19,7"], diagonal: 6.9,
        ratio: (9, 19.5), ppi: 460),
    ]
    let chip = Device.CPU.a20Pro
    XCTAssertEqual(chip.description, "A20 Pro")
    // The deferred model and unverified identifiers must remain unknown.
    for identifier in [
      "iPhone19,1", "iPhone19,5", "iPhone19,6", "placeholder:iPhone18Pro",
      "placeholder:iPhone18ProMax",
    ] {
      XCTAssertEqual(Device.mapToDevice(identifier: identifier), .unknown(identifier))
    }
    for expected in models {
      let model = expected.model
      for identifier in expected.identifiers {
        XCTAssertEqual(Device.mapToDevice(identifier: identifier), model, identifier)
      }
      XCTAssertTrue(model.isPhone)
      XCTAssertFalse(model.isPad)
      XCTAssertTrue(Device.allRealDevices.contains(model))
      XCTAssertTrue(Device.allSimulators.contains(.simulator(model)))
      for variant in [model, .simulator(model)] {
        XCTAssertEqual(variant.cpu, chip)
        XCTAssertEqual(variant.diagonal, expected.diagonal)
        XCTAssertEqual(variant.screenRatio.width, expected.ratio.0)
        XCTAssertEqual(variant.screenRatio.height, expected.ratio.1)
        XCTAssertEqual(variant.ppi, expected.ppi)
        XCTAssertTrue(variant.supportsWirelessCharging)
        XCTAssertTrue(variant.hasEsimSupport)
        XCTAssertTrue(variant.hasDualEsimSupport)
      }
    }
  }

  func testDeviceSimulator() {
    #if targetEnvironment(simulator)
      XCTAssertTrue(device.isOneOf(Device.allSimulators))
    #else
      XCTAssertFalse(device.isOneOf(Device.allSimulators))
    #endif
  }

  func testIsSimulator() {
    #if targetEnvironment(simulator)
      XCTAssertTrue(device.isSimulator)
    #else
      XCTAssertFalse(device.isSimulator)
    #endif
  }

  func testDeviceDescription() {
    #if targetEnvironment(simulator)
      XCTAssertTrue(device.description.hasPrefix("Simulator"))
      XCTAssertTrue(device.description.contains("iPhone") || device.description.contains("iPad"))
    #else
      XCTAssertFalse(device.description.hasPrefix("Simulator"))
    #endif
  }

  func testIsCanvas() {
    let otherDevice: Device = device == .iPhone14Pro ? .iPhone14ProMax : .iPhone14Pro
    XCTAssertEqual(otherDevice.isCanvas, nil)
    XCTAssertEqual(device.isCanvas, false)
  }

  func testDeviceCPU() {
    XCTAssertEqual(Device.iPhone12Mini.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPhone12.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPhone12Pro.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPhone12ProMax.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPhone13Mini.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone13.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone13Pro.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone13ProMax.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone14.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone14Plus.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPhone14Pro.cpu, Device.CPU.a16Bionic)
    XCTAssertEqual(Device.iPhone14ProMax.cpu, Device.CPU.a16Bionic)

    XCTAssertEqual(Device.iPad8.cpu, Device.CPU.a12Bionic)
    XCTAssertEqual(Device.iPad9.cpu, Device.CPU.a13Bionic)
    XCTAssertEqual(Device.iPad10.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPadAir3.cpu, Device.CPU.a12Bionic)
    XCTAssertEqual(Device.iPadAir4.cpu, Device.CPU.a14Bionic)
    XCTAssertEqual(Device.iPadAir5.cpu, Device.CPU.m1)
    XCTAssertEqual(Device.iPadMini5.cpu, Device.CPU.a12Bionic)
    XCTAssertEqual(Device.iPadMini6.cpu, Device.CPU.a15Bionic)
    XCTAssertEqual(Device.iPadMiniA17Pro.cpu, Device.CPU.a17Pro)
    XCTAssertEqual(Device.iPadPro11Inch.cpu, Device.CPU.a12XBionic)
    XCTAssertEqual(Device.iPadPro11Inch2.cpu, Device.CPU.a12ZBionic)
    XCTAssertEqual(Device.iPadPro11Inch3.cpu, Device.CPU.m1)
    XCTAssertEqual(Device.iPadPro11Inch4.cpu, Device.CPU.m2)
    XCTAssertEqual(Device.iPadPro11M4.cpu, Device.CPU.m4)
    XCTAssertEqual(Device.iPadPro13M4.cpu, Device.CPU.m4)
    XCTAssertEqual(Device.iPadPro11M5.cpu, Device.CPU.m5)
    XCTAssertEqual(Device.iPadPro13M5.cpu, Device.CPU.m5)
    XCTAssertEqual(Device.iPhone17e.cpu, Device.CPU.a19)
    XCTAssertEqual(Device.iPadAir11M4.cpu, Device.CPU.m4)
    XCTAssertEqual(Device.iPadAir13M4.cpu, Device.CPU.m4)
  }

  func testCPUDescription() {
    XCTAssertEqual(Device.CPU.a15Bionic.description, "A15 Bionic")
    XCTAssertEqual(Device.CPU.a16Bionic.description, "A16 Bionic")
    XCTAssertEqual(Device.CPU.m1.description, "M1")
    XCTAssertEqual(Device.CPU.m2.description, "M2")
    XCTAssertEqual(Device.CPU.m4.description, "M4")
    XCTAssertEqual(Device.CPU.m5.description, "M5")
  }

  // MARK: - iOS

  func testIsPhoneIsPad() {
    if ProcessInfo.processInfo.isiOSAppOnMac {
      XCTAssertFalse(device.isPhone)
      XCTAssertFalse(device.isPad)
    } else if Device.allPads.contains(device.realDevice) {
      XCTAssertTrue(device.isPad)
      XCTAssertFalse(device.isPhone)
    } else if Device.allPhones.contains(device.realDevice) {
      XCTAssertFalse(device.isPad)
      XCTAssertTrue(device.isPhone)
    }
    for pad in Device.allPads {
      XCTAssertTrue(pad.isPad)
      XCTAssertFalse(pad.isPhone)
    }
    for phone in Device.allPhones {
      XCTAssertFalse(phone.isPad)
      XCTAssertTrue(phone.isPhone)
    }
  }

  func testSystemName() {
    if ProcessInfo.processInfo.isiOSAppOnMac {
      XCTAssertEqual(device, .unknown(Device.identifier))
      XCTAssertEqual(device.systemName, "macOS")
      XCTAssertEqual(device.model, "Mac")
      XCTAssertEqual(device.localizedModel, "Mac")
      XCTAssertNotNil(device.systemVersion)
      XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,6"), .iPadPro12Inch3)
    } else if Device.allPads.contains(device.realDevice) {
      XCTAssertEqual(device.systemName, "iPadOS")
    } else if Device.allPhones.contains(device.realDevice) {
      XCTAssertEqual(device.systemName, "iOS")
    }
  }

  func testBattery() {
    XCTAssertTrue(Device.BatteryState.full > Device.BatteryState.charging(100))
    XCTAssertTrue(Device.BatteryState.charging(75) != Device.BatteryState.unplugged(75))
    XCTAssertTrue(Device.BatteryState.unplugged(2) > Device.BatteryState.charging(1))
  }

  func testMapFromIdentifier() {
    XCTAssertEqual(Device.mapToDevice(identifier: "iPhone11,2"), .iPhoneXS)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPhone11,4"), .iPhoneXSMax)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPhone11,6"), .iPhoneXSMax)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPhone11,8"), .iPhoneXR)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,1"), .iPadPro11Inch)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,2"), .iPadPro11Inch)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,3"), .iPadPro11Inch)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,4"), .iPadPro11Inch)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,5"), .iPadPro12Inch3)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,6"), .iPadPro12Inch3)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,7"), .iPadPro12Inch3)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad8,8"), .iPadPro12Inch3)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPhone18,5"), .iPhone17e)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad16,8"), .iPadAir11M4)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad16,9"), .iPadAir11M4)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad16,10"), .iPadAir13M4)
    XCTAssertEqual(Device.mapToDevice(identifier: "iPad16,11"), .iPadAir13M4)
  }

  func testScreenRatio() {
    XCTAssertTrue(Device.iPhoneSE2.screenRatio == (width: 9, height: 16))
    XCTAssertTrue(Device.iPhoneXS.screenRatio == (width: 9, height: 19.5))
    XCTAssertTrue(Device.iPhoneXSMax.screenRatio == (width: 9, height: 19.5))
    XCTAssertTrue(Device.iPhoneXR.screenRatio == (width: 9, height: 19.5))
    XCTAssertTrue(Device.iPadPro11Inch.screenRatio == (width: 139, height: 199))
    XCTAssertTrue(Device.iPadPro12Inch3.screenRatio == (width: 512, height: 683))

    XCTAssertTrue(Device.simulator(device).screenRatio == device.screenRatio)
    XCTAssertTrue(Device.unknown(UUID().uuidString).screenRatio == (width: -1, height: -1))
  }

  func testDiagonal() {
    XCTAssertEqual(Device.iPhoneXS.diagonal, 5.8)
    XCTAssertEqual(Device.iPhoneXSMax.diagonal, 6.5)
    XCTAssertEqual(Device.iPhoneXR.diagonal, 6.1)

    XCTAssertEqual(Device.iPadPro11Inch.diagonal, 11.0)
    XCTAssertEqual(Device.iPadPro12Inch3.diagonal, 12.9)

    XCTAssertEqual(Device.unknown(UUID().uuidString).diagonal, -1)
  }

  func testDescription() {
    XCTAssertEqual(Device.iPhoneXS.description, "iPhone Xs")
    XCTAssertEqual(Device.iPhoneXSMax.description, "iPhone Xs Max")
    XCTAssertEqual(Device.iPhoneXR.description, "iPhone Xʀ")
    XCTAssertEqual(Device.iPadAir3.description, "iPad Air (3rd generation)")
    XCTAssertEqual(Device.iPadMini5.description, "iPad mini (5th generation)")
    XCTAssertEqual(Device.iPadPro11Inch.description, "iPad Pro (11-inch)")
    XCTAssertEqual(Device.iPadPro12Inch3.description, "iPad Pro (12.9-inch) (3rd generation)")
    XCTAssertEqual(
      Device.simulator(Device.iPadPro11Inch).description, "Simulator (\(Device.iPadPro11Inch))")
    let uuid = UUID().uuidString
    XCTAssertEqual(Device.unknown(uuid).description, uuid)
  }

  func testSafeDescription() {
    for device in Device.allRealDevices {
      switch device {
      case .iPhoneXR, .iPhoneXS, .iPhoneXSMax:
        XCTAssertNotEqual(device.description, device.safeDescription)
      default:
        XCTAssertEqual(device.description, device.safeDescription)
      }
    }
  }

  func testIsPad() {
    Device.allPads.forEach { XCTAssertTrue($0.isPad) }
  }

  // Test that all the ppi values for applicable devices match the public information available at wikipedia.
  // Non-applicable devices return nil.
  func testPPI() {
    // swiftlint:disable comma

    assertEqualDeviceAndSimulator(device: Device.iPhoneSE2, property: \Device.ppi, value: 326)
    assertEqualDeviceAndSimulator(device: Device.iPhoneXR, property: \Device.ppi, value: 326)
    assertEqualDeviceAndSimulator(device: Device.iPhoneXS, property: \Device.ppi, value: 458)
    assertEqualDeviceAndSimulator(device: Device.iPhoneXSMax, property: \Device.ppi, value: 458)

    assertEqualDeviceAndSimulator(device: Device.iPadPro11Inch, property: \Device.ppi, value: 264)
    assertEqualDeviceAndSimulator(device: Device.iPadPro12Inch3, property: \Device.ppi, value: 264)
    // swiftlint:enable comma
  }

  func assertEqualDeviceAndSimulator<Value>(
    device: Device,
    property: KeyPath<Device, Value>,
    value: Value,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where Value: Equatable {
    let simulator = Device.simulator(device)
    XCTAssertTrue(device[keyPath: property] == value, file: file, line: line)
    XCTAssertTrue(simulator[keyPath: property] == value, file: file, line: line)
  }

  func testIsPlusSized() {
    XCTAssertEqual(
      Device.allPlusSizedDevices,
      [
        .iPhoneXSMax,
        .iPhone11ProMax,
        .iPhone12ProMax,
        .iPhone13ProMax,
        .iPhone14Plus,
        .iPhone14ProMax,
        .iPhone15Plus,
        .iPhone15ProMax,
        .iPhone16Plus,
        .iPhone16ProMax,
        .iPhone17ProMax,
        .iPhoneAir,
        .iPhone18ProMax,
      ])
  }

  func testIsPro() {
    XCTAssertEqual(
      Device.allProDevices,
      [
        .iPhone11Pro,
        .iPhone11ProMax,
        .iPhone12Pro,
        .iPhone12ProMax,
        .iPhone13Pro,
        .iPhone13ProMax,
        .iPhone14Pro,
        .iPhone14ProMax,
        .iPhone15Pro,
        .iPhone15ProMax,
        .iPhone16Pro,
        .iPhone16ProMax,
        .iPhone17Pro,
        .iPhone17ProMax,
        .iPhone18Pro,
        .iPhone18ProMax,
        .iPadPro11Inch,
        .iPadPro12Inch3,
        .iPadPro11Inch2,
        .iPadPro12Inch4,
        .iPadPro11Inch3,
        .iPadPro12Inch5,
        .iPadPro11Inch4,
        .iPadPro12Inch6,
        .iPadPro11M4,
        .iPadPro13M4,
        .iPadPro11M5,
        .iPadPro13M5,
      ])
  }

  func testGuidedAccessSession() {
    XCTAssertFalse(Device.current.isGuidedAccessSessionActive)
  }

  func testKeepsBatteryMonitoringState() {
    let original = UIDevice.current.isBatteryMonitoringEnabled
    defer { UIDevice.current.isBatteryMonitoringEnabled = original }
    for requested in [false, true] {
      UIDevice.current.isBatteryMonitoringEnabled = requested
      // Simulator can reject enabling battery monitoring. Preserve the accepted state.
      let accepted = UIDevice.current.isBatteryMonitoringEnabled
      #if !targetEnvironment(simulator)
        XCTAssertEqual(accepted, requested)
      #endif
      let state = Device.current.batteryState
      XCTAssertNotNil(state)
      XCTAssertEqual(UIDevice.current.isBatteryMonitoringEnabled, accepted)
      let level = Device.current.batteryLevel
      XCTAssertNotNil(level)
      XCTAssertEqual(UIDevice.current.isBatteryMonitoringEnabled, accepted)
    }
  }

  func testHasDynamicIsland() {
    let dynamicIslandDevices: [Device] = [
      .iPhoneDuo,
      .iPhone14Pro,
      .iPhone14ProMax,
      .iPhone15,
      .iPhone15Plus,
      .iPhone15Pro,
      .iPhone15ProMax,
      .iPhone16,
      .iPhone16Plus,
      .iPhone16Pro,
      .iPhone16ProMax,
      .iPhone17,
      .iPhone17Pro,
      .iPhone17ProMax,
      .iPhone18Pro,
      .iPhone18ProMax,
      .iPhoneAir,
    ]
    for device in Device.allRealDevices {
      XCTAssertTrue(
        device.hasDynamicIsland == device.isOneOf(dynamicIslandDevices),
        "testHasDynamicIsland failed for \(device.description)")
    }
  }

  func testHas5gSupport() {
    let has5gDevices: [Device] = [
      .iPhoneDuo,
      .iPhone12,
      .iPhone12Mini,
      .iPhone12Pro,
      .iPhone12ProMax,
      .iPhone13,
      .iPhone13Mini,
      .iPhone13Pro,
      .iPhone13ProMax,
      .iPhoneSE3,
      .iPhone14,
      .iPhone14Plus,
      .iPhone14Pro,
      .iPhone14ProMax,
      .iPhone15,
      .iPhone15Plus,
      .iPhone15Pro,
      .iPhone15ProMax,
      .iPhone16,
      .iPhone16Plus,
      .iPhone16Pro,
      .iPhone16ProMax,
      .iPhone16e,
      .iPhone17,
      .iPhone17Pro,
      .iPhone17ProMax,
      .iPhone18Pro,
      .iPhone18ProMax,
      .iPhoneAir,
      .iPhone17e,
      .iPad10,
      .iPadA16,
      .iPadAir5,
      .iPadAir11M2,
      .iPadAir13M2,
      .iPadAir11M3,
      .iPadAir13M3,
      .iPadAir11M4,
      .iPadAir13M4,
      .iPadMini6,
      .iPadMiniA17Pro, .iPadMiniA20Pro,
      .iPadPro11Inch3,
      .iPadPro12Inch5,
      .iPadPro11Inch4,
      .iPadPro12Inch6,
      .iPadPro11M4,
      .iPadPro13M4,
      .iPadPro11M5,
      .iPadPro13M5,
    ]
    for device in Device.allRealDevices {
      XCTAssertTrue(
        device.has5gSupport == device.isOneOf(has5gDevices),
        "testHas5gSupport failed for \(device.description)")
    }
  }

  func testEsimSupportBoundaries() {
    // eSIM starts with XS/XR; dual eSIM starts with iPhone 13 and SE (3rd generation).
    let unsupported: [Device] = [
      .unknown("future device")
    ]
    let esimOnly: [Device] = [
      .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhoneSE2,
      .iPhone12, .iPhone12Mini, .iPhone12Pro, .iPhone12ProMax,
      .iPad7, .iPadAir3, .iPadMini5, .iPadPro11Inch, .iPadPro12Inch3,
    ]
    let dualEsim: [Device] = [.iPhone13, .iPhone13Mini, .iPhone13Pro, .iPhone13ProMax, .iPhoneSE3]
    for model in unsupported + esimOnly + dualEsim {
      for variant in [model, .simulator(model)] {
        XCTAssertEqual(variant.hasEsimSupport, !unsupported.contains(model), "\(variant)")
        XCTAssertEqual(variant.hasDualEsimSupport, dualEsim.contains(model), "\(variant)")
      }
    }
  }

  func testRecentDevicesEsimSupport() {
    let phones: [Device] = [
      .iPhone16, .iPhone16Plus, .iPhone16Pro, .iPhone16ProMax, .iPhone16e,
      .iPhone17, .iPhone17Pro, .iPhone17ProMax, .iPhoneAir, .iPhone17e,
    ]
    let pads: [Device] = [
      .iPadAir11M2, .iPadAir13M2, .iPadPro11M4, .iPadPro13M4,
      .iPadMiniA17Pro, .iPadMiniA20Pro, .iPadA16, .iPadAir11M3, .iPadAir13M3,
      .iPadPro11M5, .iPadPro13M5, .iPadAir11M4, .iPadAir13M4,
    ]
    for model in phones + pads {
      for variant in [model, .simulator(model)] {
        XCTAssertTrue(variant.hasEsimSupport, "\(variant)")
        XCTAssertEqual(variant.hasDualEsimSupport, phones.contains(model), "\(variant)")
      }
    }
  }

  func testEsimDeviceLists() {
    for model in Device.allDevicesWithDualEsimSupport {
      XCTAssertTrue(Device.allDevicesWithEsimSupport.contains(model), "\(model)")
      XCTAssertTrue(model.isPhone)
    }
    for model in Device.allRealDevices {
      XCTAssertEqual(Device.allDevicesWithEsimSupport.contains(model), model.hasEsimSupport)
      XCTAssertEqual(Device.allDevicesWithDualEsimSupport.contains(model), model.hasDualEsimSupport)
    }
    XCTAssertFalse(Device.allDevicesWithDualEsimSupport.contains(.iPhone12))
  }

  // MARK: - volumes
  func testVolumeTotalCapacity() {
    XCTAssertNotNil(Device.volumeTotalCapacity)
  }

  func testVolumeAvailableCapacity() {
    XCTAssertNotNil(Device.volumeAvailableCapacity)
  }

  func testVolumeAvailableCapacityForImportantUsage() {
    XCTAssertNotNil(Device.volumeAvailableCapacityForImportantUsage)
  }

  func testVolumeAvailableCapacityForOpportunisticUsage() {
    XCTAssertNotNil(Device.volumeAvailableCapacityForOpportunisticUsage)
  }

  func testVolumes() {
    XCTAssertNotNil(Device.volumes)
  }

  func testCameras() {
    for device in Device.allDevicesWithCamera {
      XCTAssertTrue(
        device.cameras.contains(.wide) || device.cameras.contains(.telephoto)
          || device.cameras.contains(.ultraWide))
      XCTAssertTrue(device.hasCamera)
      XCTAssertTrue(device.hasWideCamera || device.hasTelephotoCamera || device.hasUltraWideCamera)
    }
    let devices = Device.allRealDevices
    for device in devices where !Device.allDevicesWithCamera.contains(device) {
      XCTAssertFalse(device.cameras.contains(.wide))
      XCTAssertFalse(device.cameras.contains(.telephoto))
      XCTAssertFalse(device.cameras.contains(.ultraWide))
      XCTAssertFalse(device.hasCamera)
      XCTAssertFalse(device.hasWideCamera)
      XCTAssertFalse(device.hasTelephotoCamera)
      XCTAssertFalse(device.hasUltraWideCamera)
    }
    for device in Device.allDevicesWithWideCamera {
      XCTAssertTrue(device.cameras.contains(.wide))
      XCTAssertTrue(device.hasCamera)
      XCTAssertTrue(device.hasWideCamera)
    }
    for device in Device.allDevicesWithTelephotoCamera {
      XCTAssertTrue(device.cameras.contains(.telephoto))
      XCTAssertTrue(device.hasCamera)
      XCTAssertTrue(device.hasTelephotoCamera)
    }
    for device in Device.allDevicesWithUltraWideCamera {
      XCTAssertTrue(device.cameras.contains(.ultraWide))
      XCTAssertTrue(device.hasCamera)
      XCTAssertTrue(device.hasUltraWideCamera)
    }
  }

  func testLidarValues() {
    let lidarDevices: [Device] = [
      .iPhone12Pro,
      .iPhone12ProMax,
      .iPhone13Pro,
      .iPhone13ProMax,
      .iPhone14Pro,
      .iPhone14ProMax,
      .iPhone15Pro,
      .iPhone15ProMax,
      .iPhone16Pro,
      .iPhone16ProMax,
      .iPhone17Pro,
      .iPhone17ProMax,
      .iPhone18Pro,
      .iPhone18ProMax,
      .iPadPro11Inch2,
      .iPadPro12Inch4,
      .iPadPro11Inch3,
      .iPadPro12Inch5,
      .iPadPro11Inch4,
      .iPadPro12Inch6,
      .iPadPro11M4,
      .iPadPro13M4,
      .iPadPro11M5,
      .iPadPro13M5,
    ]
    for device in Device.allRealDevices {
      XCTAssertTrue(
        device.hasLidarSensor == device.isOneOf(lidarDevices),
        "testLidarValues failed for \(device.description)")
    }
  }

  func testHasUSBCConnectivity() {
    let usbCDevices: [Device] = [
      .iPhoneDuo,
      .iPhone15,
      .iPhone15Plus,
      .iPhone15Pro,
      .iPhone15ProMax,
      .iPhone16,
      .iPhone16Plus,
      .iPhone16Pro,
      .iPhone16ProMax,
      .iPhone16e,
      .iPhone17,
      .iPhone17Pro,
      .iPhone17ProMax,
      .iPhone18Pro,
      .iPhone18ProMax,
      .iPhoneAir,
      .iPhone17e,
      .iPad10,
      .iPadA16,
      .iPadAir4,
      .iPadAir5,
      .iPadAir11M2,
      .iPadAir13M2,
      .iPadAir11M3,
      .iPadAir13M3,
      .iPadAir11M4,
      .iPadAir13M4,
      .iPadMini6,
      .iPadMiniA17Pro, .iPadMiniA20Pro,
      .iPadPro11Inch,
      .iPadPro12Inch3,
      .iPadPro11Inch2,
      .iPadPro12Inch4,
      .iPadPro11Inch3,
      .iPadPro12Inch5,
      .iPadPro11Inch4,
      .iPadPro12Inch6,
      .iPadPro11M4,
      .iPadPro13M4,
      .iPadPro11M5,
      .iPadPro13M5,
    ]
    for device in Device.allRealDevices {
      XCTAssertTrue(
        device.hasUSBCConnectivity == device.isOneOf(usbCDevices),
        "testHasUSBCConnectivity failed for \(device.description)")
    }
  }

  func testApplePencilSupport() {
    // Test iPad (10th gen) - Supports Apple Pencil (1st gen) and Apple Pencil (USB-C)
    XCTAssertTrue(Device.iPad10.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPad10.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPad10.applePencilSupport.contains(.secondGeneration))
    XCTAssertFalse(Device.iPad10.applePencilSupport.contains(.pro))

    // Test iPad (A16) - Supports Apple Pencil (1st gen) and Apple Pencil (USB-C)
    XCTAssertTrue(Device.iPadA16.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadA16.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadA16.applePencilSupport.contains(.secondGeneration))
    XCTAssertFalse(Device.iPadA16.applePencilSupport.contains(.pro))

    // Test iPad Air 11" (M2) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadAir11M2.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadAir11M2.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadAir11M2.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadAir11M2.applePencilSupport.contains(.pro))

    // Test iPad Air 13" (M2) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadAir13M2.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadAir13M2.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadAir13M2.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadAir13M2.applePencilSupport.contains(.pro))

    // Test iPad Air 11" (M3) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadAir11M3.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadAir11M3.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadAir11M3.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadAir11M3.applePencilSupport.contains(.pro))

    // Test iPad Air 13" (M3) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadAir13M3.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadAir13M3.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadAir13M3.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadAir13M3.applePencilSupport.contains(.pro))

    // Test iPad Pro 11" (M4) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadPro11M4.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadPro11M4.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadPro11M4.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadPro11M4.applePencilSupport.contains(.pro))

    // Test iPad Pro 13" (M4) - Supports Apple Pencil Pro and Apple Pencil (USB-C)
    XCTAssertFalse(Device.iPadPro13M4.applePencilSupport.contains(.firstGeneration))
    XCTAssertTrue(Device.iPadPro13M4.applePencilSupport.contains(.firstGenerationUsbC))
    XCTAssertFalse(Device.iPadPro13M4.applePencilSupport.contains(.secondGeneration))
    XCTAssertTrue(Device.iPadPro13M4.applePencilSupport.contains(.pro))
  }

}
