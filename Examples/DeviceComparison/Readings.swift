import Foundation
@preconcurrency import DeviceKit
import SwiftDeviceKitSystem

typealias Original = DeviceKit.Device
typealias Local = SwiftDeviceKitSystem.Device

struct Reading: Codable, Identifiable {
  let field: String
  let original: String?
  let local: String?
  var id: String { field }

  // nil in a column means that this library has no API on this platform.
  // A getter that actually returns nil is recorded as the string "nil".
  init(_ field: String, _ original: String?, _ local: String?) {
    self.field = field
    self.original = original
    self.local = local
  }
}

func value<T>(_ input: T?) -> String {
  input.map { String(describing: $0) } ?? "nil"
}

@MainActor
enum Readings {
  static func catalog(_ a: Original, _ b: Local) -> [Reading] {
    let base = Original.realDevice(from: a)
    var rows = [
      Reading("description", a.description, b.description),
      Reading("safeDescription", a.safeDescription, b.safeDescription),
      Reading("realDevice", base.description, b.realDevice.description),
      Reading("cpu", a.cpu.description, b.cpu.description),
      Reading("isSimulator", value(a.isSimulator), value(b.isSimulator)),
      Reading("isFoldable", value(a.isFoldable), value(b.isFoldable)),
      Reading("screenRatio", value(a.screenRatio), value(b.screenRatio)),
      Reading("ppi", value(a.ppi), value(b.ppi)),
      Reading("isCanvas", value(a.isCanvas), value(b.isCanvas)),
    ]
    #if os(iOS) || os(watchOS)
    rows.append(Reading("diagonal", value(a.diagonal), value(b.diagonal)))
    #endif
    #if os(watchOS)
    rows.append(Reading("hasForceTouchSupport", value(a.hasForceTouchSupport), value(b.hasForceTouchSupport)))
    #endif
    #if os(iOS)
    rows += [
      Reading("isPhone", value(a.isPhone), value(b.isPhone)),
      Reading("isPad", value(a.isPad), value(b.isPad)),
      Reading("isPod", value(a.isPod), nil),
      Reading("applePencilSupport", pencil(a.applePencilSupport.rawValue), pencil(b.applePencilSupport.rawValue)),
      Reading("cameras", a.cameras.map { value($0) }.joined(separator: ", "), b.cameras.map { value($0) }.joined(separator: ", ")),
      Reading("isTouchIDCapable", value(a.isTouchIDCapable), value(b.isTouchIDCapable)),
      Reading("isFaceIDCapable", value(a.isFaceIDCapable), value(b.isFaceIDCapable)),
      Reading("hasBiometricSensor", value(a.hasBiometricSensor), value(b.hasBiometricSensor)),
      Reading("hasSensorHousing", value(a.hasSensorHousing), value(b.hasSensorHousing)),
      Reading("hasRoundedDisplayCorners", value(a.hasRoundedDisplayCorners), value(b.hasRoundedDisplayCorners)),
      Reading("hasDynamicIsland", value(a.hasDynamicIsland), value(b.hasDynamicIsland)),
      Reading("has3dTouchSupport", value(a.has3dTouchSupport), value(b.has3dTouchSupport)),
      Reading("supportsWirelessCharging", value(a.supportsWirelessCharging), value(b.supportsWirelessCharging)),
      Reading("has5gSupport", value(a.has5gSupport), value(b.has5gSupport)),
      Reading("hasEsimSupport", value(a.hasEsimSupport), value(b.hasEsimSupport)),
      Reading("hasDualEsimSupport", value(a.hasDualEsimSupport), value(b.hasDualEsimSupport)),
      Reading("hasLidarSensor", value(a.hasLidarSensor), value(b.hasLidarSensor)),
      Reading("hasUSBCConnectivity", value(a.hasUSBCConnectivity), value(b.hasUSBCConnectivity)),
      Reading("hasCamera", value(a.hasCamera), value(b.hasCamera)),
      Reading("hasNormalCamera", value(a.hasNormalCamera), value(b.hasNormalCamera)),
      Reading("hasWideCamera", value(a.hasWideCamera), value(b.hasWideCamera)),
      Reading("hasTelephotoCamera", value(a.hasTelephotoCamera), value(b.hasTelephotoCamera)),
      Reading("hasUltraWideCamera", value(a.hasUltraWideCamera), value(b.hasUltraWideCamera)),
    ]
    #endif
    rows += [
      Reading("family", nil, value(b.family)),
      Reading("hasActionButton", nil, value(b.hasActionButton)),
      Reading("hasVariableAperture", nil, value(b.hasVariableAperture)),
      Reading("isOpticIDCapable", nil, value(b.isOpticIDCapable)),
      Reading("screens", nil, b.screens.map { screen in
        let pixels = screen.resolution.map { "\($0.width)×\($0.height)" } ?? "—"
        return "\(screen.role) · \(screen.diagonal)″ · \(screen.ppi) ppi · \(pixels) · \(screen.screenRatio.width):\(screen.screenRatio.height)"
      }.joined(separator: " / ")),
      Reading("spatialDisplay", nil, b.spatialDisplay.map {
        "\($0.approximateTotalPixels) px · \($0.pixelPitchMicrometers) µm · \($0.refreshRatesHz) Hz"
      } ?? "nil"),
    ]
    return rows
  }

  static func pencil(_ mask: UInt) -> String {
    let options: [(UInt, String)] = [(1, "1st gen"), (2, "2nd gen"), (4, "USB-C"), (8, "Pro")]
    let names = options.filter { mask & $0.0 != 0 }.map(\.1)
    return names.isEmpty ? "[]" : names.joined(separator: ", ")
  }

  static func system(_ a: Original, _ b: Local) -> [Reading] {
    var rows = [
      Reading("identifier", Original.identifier, Local.identifier),
      Reading("name", value(a.name), value(b.name)),
      Reading("systemName", value(a.systemName), value(b.systemName)),
      Reading("systemVersion", value(a.systemVersion), value(b.systemVersion)),
      Reading("model", value(a.model), value(b.model)),
      Reading("localizedModel", value(a.localizedModel), value(b.localizedModel)),
      Reading("thermalState", value(a.thermalState), value(b.thermalState)),
      Reading("isGuidedAccessSessionActive", value(a.isGuidedAccessSessionActive), value(b.isGuidedAccessSessionActive)),
      Reading("isLowPowerModeEnabled", nil, value(b.isLowPowerModeEnabled)),
    ]
    #if os(iOS) || os(watchOS) || os(tvOS)
    rows.append(Reading("screenBrightness", value(a.screenBrightness), value(b.screenBrightness)))
    #endif
    #if !os(visionOS)
    rows.append(Reading("currentDisplayPixels", nil, value(b.currentDisplayPixels)))
    #endif
    #if os(iOS) || os(watchOS)
    rows += [
      Reading("batteryState", value(a.batteryState), value(b.batteryState)),
      Reading("batteryLevel", value(a.batteryLevel), value(b.batteryLevel)),
      Reading("batteryState.lowPowerMode", value(a.batteryState?.lowPowerMode), value(b.batteryState?.lowPowerMode)),
    ]
    #elseif !os(tvOS)
    rows += [Reading("batteryState", nil, value(b.batteryState)), Reading("batteryLevel", nil, value(b.batteryLevel))]
    #endif
    #if os(iOS)
    rows += [
      Reading("orientation", value(a.orientation), value(b.orientation)),
      Reading("isZoomed", value(a.isZoomed), value(b.isZoomed)),
      Reading("volumeTotalCapacity", value(Original.volumeTotalCapacity), value(Local.volumeTotalCapacity)),
      Reading("volumeAvailableCapacity", value(Original.volumeAvailableCapacity), value(Local.volumeAvailableCapacity)),
      Reading("volumeAvailableCapacityForImportantUsage", value(Original.volumeAvailableCapacityForImportantUsage), value(Local.volumeAvailableCapacityForImportantUsage)),
      Reading("volumeAvailableCapacityForOpportunisticUsage", value(Original.volumeAvailableCapacityForOpportunisticUsage), value(Local.volumeAvailableCapacityForOpportunisticUsage)),
      Reading("volumes", summary(Original.volumes), summary(Local.volumes)),
    ]
    #else
    rows += [Reading("volumeTotalCapacity", nil, value(Local.volumeTotalCapacity)),
             Reading("volumeAvailableCapacity", nil, value(Local.volumeAvailableCapacity))]
    #endif
    return rows
  }

  static func summary(_ volumes: [URLResourceKey: Int64]?) -> String {
    volumes?.map { "\($0.key.rawValue)=\($0.value)" }.sorted().joined(separator: ", ") ?? "nil"
  }
}
