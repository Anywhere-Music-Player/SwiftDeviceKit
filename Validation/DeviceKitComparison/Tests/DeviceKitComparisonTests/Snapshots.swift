import Foundation
@preconcurrency import DeviceKit
@testable import SwiftDeviceKitCore
import SwiftDeviceKitSystem

// Independent, typed adapters call each library's actual public API.
// Exact strings are intentional: model names can be persisted in application paths.
struct Snapshot: Equatable {
  var fields: [String: String]
}

private func text<T>(_ value: T?) -> String {
  value.map { String(describing: $0) } ?? "nil"
}

@MainActor
enum Snapshots {
  static func read(_ device: DeviceKit.Device) -> Snapshot {
    let kind: String
    if case .unknown = device.realDevice { kind = "unknown" } else { kind = "known" }
    var pencil: [String] = []
    if device.applePencilSupport.contains(.firstGeneration) { pencil.append("firstGeneration") }
    if device.applePencilSupport.contains(.secondGeneration) { pencil.append("secondGeneration") }
    if device.applePencilSupport.contains(.firstGenerationUsbC) { pencil.append("firstGenerationUsbC") }
    if device.applePencilSupport.contains(.pro) { pencil.append("pro") }
    return Snapshot(fields: [
      "kind": kind,
      "cameras": device.cameras.map { String(describing: $0) }.joined(separator: ","),
      "applePencilSupport": pencil.joined(separator: ","),
      "description": text(device.description),
      "safeDescription": text(device.safeDescription),
      "realDevice.description": text(device.realDevice.description),
      "diagonal": text(device.diagonal),
      "screenRatio.width": text(device.screenRatio.width),
      "screenRatio.height": text(device.screenRatio.height),
      "ppi": text(device.ppi),
      "cpu.description": text(device.cpu.description),
      "isSimulator": text(device.isSimulator),
      "isPhone": text(device.isPhone),
      "isPad": text(device.isPad),
      "isTouchIDCapable": text(device.isTouchIDCapable),
      "isFaceIDCapable": text(device.isFaceIDCapable),
      "hasBiometricSensor": text(device.hasBiometricSensor),
      "hasSensorHousing": text(device.hasSensorHousing),
      "hasRoundedDisplayCorners": text(device.hasRoundedDisplayCorners),
      "hasDynamicIsland": text(device.hasDynamicIsland),
      "has3dTouchSupport": text(device.has3dTouchSupport),
      "supportsWirelessCharging": text(device.supportsWirelessCharging),
      "has5gSupport": text(device.has5gSupport),
      "hasEsimSupport": text(device.hasEsimSupport),
      "hasDualEsimSupport": text(device.hasDualEsimSupport),
      "hasLidarSensor": text(device.hasLidarSensor),
      "hasUSBCConnectivity": text(device.hasUSBCConnectivity),
      "hasCamera": text(device.hasCamera),
      "hasWideCamera": text(device.hasWideCamera),
      "hasTelephotoCamera": text(device.hasTelephotoCamera),
      "hasUltraWideCamera": text(device.hasUltraWideCamera),
      "isCanvas": text(device.isCanvas),
    ])
  }

  static func read(_ device: SwiftDeviceKitCore.Device) -> Snapshot {
    let kind: String
    if case .unknown = device.realDevice { kind = "unknown" } else { kind = "known" }
    var pencil: [String] = []
    if device.applePencilSupport.contains(.firstGeneration) { pencil.append("firstGeneration") }
    if device.applePencilSupport.contains(.secondGeneration) { pencil.append("secondGeneration") }
    if device.applePencilSupport.contains(.firstGenerationUsbC) { pencil.append("firstGenerationUsbC") }
    if device.applePencilSupport.contains(.pro) { pencil.append("pro") }
    return Snapshot(fields: [
      "kind": kind,
      "cameras": device.cameras.map { String(describing: $0) }.joined(separator: ","),
      "applePencilSupport": pencil.joined(separator: ","),
      "description": text(device.description),
      "safeDescription": text(device.safeDescription),
      "realDevice.description": text(device.realDevice.description),
      "diagonal": text(device.diagonal),
      "screenRatio.width": text(device.screenRatio.width),
      "screenRatio.height": text(device.screenRatio.height),
      "ppi": text(device.ppi),
      "cpu.description": text(device.cpu.description),
      "isSimulator": text(device.isSimulator),
      "isPhone": text(device.isPhone),
      "isPad": text(device.isPad),
      "isTouchIDCapable": text(device.isTouchIDCapable),
      "isFaceIDCapable": text(device.isFaceIDCapable),
      "hasBiometricSensor": text(device.hasBiometricSensor),
      "hasSensorHousing": text(device.hasSensorHousing),
      "hasRoundedDisplayCorners": text(device.hasRoundedDisplayCorners),
      "hasDynamicIsland": text(device.hasDynamicIsland),
      "has3dTouchSupport": text(device.has3dTouchSupport),
      "supportsWirelessCharging": text(device.supportsWirelessCharging),
      "has5gSupport": text(device.has5gSupport),
      "hasEsimSupport": text(device.hasEsimSupport),
      "hasDualEsimSupport": text(device.hasDualEsimSupport),
      "hasLidarSensor": text(device.hasLidarSensor),
      "hasUSBCConnectivity": text(device.hasUSBCConnectivity),
      "hasCamera": text(device.hasCamera),
      "hasWideCamera": text(device.hasWideCamera),
      "hasTelephotoCamera": text(device.hasTelephotoCamera),
      "hasUltraWideCamera": text(device.hasUltraWideCamera),
      "isCanvas": text(device.isCanvas),
    ])
  }

  static var originalGroups: [String: [String]] {
    [
      "allPhones": DeviceKit.Device.allPhones.map(\.description),
      "allPads": DeviceKit.Device.allPads.map(\.description),
      "allPlusSizedDevices": DeviceKit.Device.allPlusSizedDevices.map(\.description),
      "allProDevices": DeviceKit.Device.allProDevices.map(\.description),
      "allMiniDevices": DeviceKit.Device.allMiniDevices.map(\.description),
      "allXSeriesDevices": DeviceKit.Device.allXSeriesDevices.map(\.description),
      "allTouchIDCapableDevices": DeviceKit.Device.allTouchIDCapableDevices.map(\.description),
      "allFaceIDCapableDevices": DeviceKit.Device.allFaceIDCapableDevices.map(\.description),
      "allBiometricAuthenticationCapableDevices": DeviceKit.Device.allBiometricAuthenticationCapableDevices.map(\.description),
      "allDevicesWithSensorHousing": DeviceKit.Device.allDevicesWithSensorHousing.map(\.description),
      "allDevicesWithRoundedDisplayCorners": DeviceKit.Device.allDevicesWithRoundedDisplayCorners.map(\.description),
      "allDevicesWithDynamicIsland": DeviceKit.Device.allDevicesWithDynamicIsland.map(\.description),
      "allDevicesWith3dTouchSupport": DeviceKit.Device.allDevicesWith3dTouchSupport.map(\.description),
      "allDevicesWithWirelessChargingSupport": DeviceKit.Device.allDevicesWithWirelessChargingSupport.map(\.description),
      "allDevicesWith5gSupport": DeviceKit.Device.allDevicesWith5gSupport.map(\.description),
      "allDevicesWithEsimSupport": DeviceKit.Device.allDevicesWithEsimSupport.map(\.description),
      "allDevicesWithDualEsimSupport": DeviceKit.Device.allDevicesWithDualEsimSupport.map(\.description),
      "allDevicesWithALidarSensor": DeviceKit.Device.allDevicesWithALidarSensor.map(\.description),
      "allDevicesWithUSBCConnectivity": DeviceKit.Device.allDevicesWithUSBCConnectivity.map(\.description),
      "allApplePencilCapableDevices": DeviceKit.Device.allApplePencilCapableDevices.map(\.description),
      "allDevicesWithCamera": DeviceKit.Device.allDevicesWithCamera.map(\.description),
      "allDevicesWithNormalCamera": DeviceKit.Device.allDevicesWithNormalCamera.map(\.description),
      "allDevicesWithWideCamera": DeviceKit.Device.allDevicesWithWideCamera.map(\.description),
      "allDevicesWithTelephotoCamera": DeviceKit.Device.allDevicesWithTelephotoCamera.map(\.description),
      "allDevicesWithUltraWideCamera": DeviceKit.Device.allDevicesWithUltraWideCamera.map(\.description),
      "allSimulatorPhones": DeviceKit.Device.allSimulatorPhones.map(\.description),
      "allSimulatorPads": DeviceKit.Device.allSimulatorPads.map(\.description),
      "allSimulatorMiniDevices": DeviceKit.Device.allSimulatorMiniDevices.map(\.description),
      "allSimulatorXSeriesDevices": DeviceKit.Device.allSimulatorXSeriesDevices.map(\.description),
      "allSimulatorPlusSizedDevices": DeviceKit.Device.allSimulatorPlusSizedDevices.map(\.description),
      "allSimulatorProDevices": DeviceKit.Device.allSimulatorProDevices.map(\.description),
      "allSimulatorDevicesWithSensorHousing": DeviceKit.Device.allSimulatorDevicesWithSensorHousing.map(\.description),
      "allRealDevices": DeviceKit.Device.allRealDevices.map(\.description),
      "allSimulators": DeviceKit.Device.allSimulators.map(\.description),
    ]
  }
  static var replacementGroups: [String: [String]] {
    [
      "allPhones": SwiftDeviceKitCore.Device.allPhones.map(\.description),
      "allPads": SwiftDeviceKitCore.Device.allPads.map(\.description),
      "allPlusSizedDevices": SwiftDeviceKitCore.Device.allPlusSizedDevices.map(\.description),
      "allProDevices": SwiftDeviceKitCore.Device.allProDevices.map(\.description),
      "allMiniDevices": SwiftDeviceKitCore.Device.allMiniDevices.map(\.description),
      "allXSeriesDevices": SwiftDeviceKitCore.Device.allXSeriesDevices.map(\.description),
      "allTouchIDCapableDevices": SwiftDeviceKitCore.Device.allTouchIDCapableDevices.map(\.description),
      "allFaceIDCapableDevices": SwiftDeviceKitCore.Device.allFaceIDCapableDevices.map(\.description),
      "allBiometricAuthenticationCapableDevices": SwiftDeviceKitCore.Device.allBiometricAuthenticationCapableDevices.map(\.description),
      "allDevicesWithSensorHousing": SwiftDeviceKitCore.Device.allDevicesWithSensorHousing.map(\.description),
      "allDevicesWithRoundedDisplayCorners": SwiftDeviceKitCore.Device.allDevicesWithRoundedDisplayCorners.map(\.description),
      "allDevicesWithDynamicIsland": SwiftDeviceKitCore.Device.allDevicesWithDynamicIsland.map(\.description),
      "allDevicesWith3dTouchSupport": SwiftDeviceKitCore.Device.allDevicesWith3dTouchSupport.map(\.description),
      "allDevicesWithWirelessChargingSupport": SwiftDeviceKitCore.Device.allDevicesWithWirelessChargingSupport.map(\.description),
      "allDevicesWith5gSupport": SwiftDeviceKitCore.Device.allDevicesWith5gSupport.map(\.description),
      "allDevicesWithEsimSupport": SwiftDeviceKitCore.Device.allDevicesWithEsimSupport.map(\.description),
      "allDevicesWithDualEsimSupport": SwiftDeviceKitCore.Device.allDevicesWithDualEsimSupport.map(\.description),
      "allDevicesWithALidarSensor": SwiftDeviceKitCore.Device.allDevicesWithALidarSensor.map(\.description),
      "allDevicesWithUSBCConnectivity": SwiftDeviceKitCore.Device.allDevicesWithUSBCConnectivity.map(\.description),
      "allApplePencilCapableDevices": SwiftDeviceKitCore.Device.allApplePencilCapableDevices.map(\.description),
      "allDevicesWithCamera": SwiftDeviceKitCore.Device.allDevicesWithCamera.map(\.description),
      "allDevicesWithNormalCamera": SwiftDeviceKitCore.Device.allDevicesWithNormalCamera.map(\.description),
      "allDevicesWithWideCamera": SwiftDeviceKitCore.Device.allDevicesWithWideCamera.map(\.description),
      "allDevicesWithTelephotoCamera": SwiftDeviceKitCore.Device.allDevicesWithTelephotoCamera.map(\.description),
      "allDevicesWithUltraWideCamera": SwiftDeviceKitCore.Device.allDevicesWithUltraWideCamera.map(\.description),
      "allSimulatorPhones": SwiftDeviceKitCore.Device.allSimulatorPhones.map(\.description),
      "allSimulatorPads": SwiftDeviceKitCore.Device.allSimulatorPads.map(\.description),
      "allSimulatorMiniDevices": SwiftDeviceKitCore.Device.allSimulatorMiniDevices.map(\.description),
      "allSimulatorXSeriesDevices": SwiftDeviceKitCore.Device.allSimulatorXSeriesDevices.map(\.description),
      "allSimulatorPlusSizedDevices": SwiftDeviceKitCore.Device.allSimulatorPlusSizedDevices.map(\.description),
      "allSimulatorProDevices": SwiftDeviceKitCore.Device.allSimulatorProDevices.map(\.description),
      "allSimulatorDevicesWithSensorHousing": SwiftDeviceKitCore.Device.allSimulatorDevicesWithSensorHousing.map(\.description),
      "allRealDevices": SwiftDeviceKitCore.Device.allRealDevices.map(\.description),
      "allSimulators": SwiftDeviceKitCore.Device.allSimulators.map(\.description),
    ]
  }
}
