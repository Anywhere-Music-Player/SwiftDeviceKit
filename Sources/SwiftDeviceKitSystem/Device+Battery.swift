// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
import Foundation
#if os(macOS) || targetEnvironment(macCatalyst)
import IOKit.ps
#elseif os(watchOS)
import WatchKit
#elseif !os(tvOS)
import UIKit
#endif

#if !os(tvOS)

// MARK: Battery

extension Device {
  /**
   This enum describes the state of the battery.

   - Full:      The OS reports the battery as charged. On Mac, batteryLevel can still be below 100%.
   - Charging:  The battery is charging.
   - Plugged in, not charging (Mac): External power is connected and charging is inactive.
   - Unplugged: The device is not plugged into power; the battery is discharging.
   */
  public enum BatteryState: CustomStringConvertible, Equatable, Sendable {
    /// The OS reports the battery as charged. On Mac, batteryLevel can still be below 100%.
    case full
    /// The battery is charging.
    /// The associated value is in percent (0-100).
    case charging(Int)
    #if os(macOS) || targetEnvironment(macCatalyst)
    /// External power is connected and the battery is not charging, for example during an optimized charging hold.
    case pluggedInNotCharging(Int)
    #endif
    /// The device is not plugged into power; the battery is discharging.
    /// The associated value is in percent (0-100).
    case unplugged(Int)

    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if os(watchOS)
    typealias ReportedState = WKInterfaceDeviceBatteryState
    #else
    typealias ReportedState = UIDevice.BatteryState
    #endif

    @MainActor
    fileprivate init?(for model: Device) {
      #if os(watchOS)
        let device = WKInterfaceDevice.current()
      #else
        let device = UIDevice.current
      #endif
      let previous = device.isBatteryMonitoringEnabled
      device.isBatteryMonitoringEnabled = true
      defer { device.isBatteryMonitoringEnabled = previous }
      self.init(reportedState: device.batteryState, level: device.batteryLevel, model: model)
    }

    init?(reportedState: ReportedState, level: Float, model: Device) {
      switch reportedState {
      case .charging, .unplugged:
        guard (0...1).contains(level) else { return nil }
        let percent = Int((level * 100).rounded())
        self = reportedState == .charging ? .charging(percent) : .unplugged(percent)
      case .full: self = .full
      case .unknown:
        #if os(visionOS)
          return nil
        #else
          guard model.isSimulator, !model.isVision else { return nil }
          self = .full
        #endif
      @unknown default: return nil
      }
    }
    #endif

    /// The user enabled Low Power mode
    public var lowPowerMode: Bool {
      return ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    /// Provides a textual representation of the battery state.
    /// Examples:
    /// ```
    /// Battery level: 90%, device is plugged in.
    /// Battery level: 100 % (Full), device is plugged in.
    /// Battery level: \(batteryLevel)%, device is unplugged.
    /// ```
    public var description: String {
      switch self {
      case .charging(let batteryLevel):
        return "Battery level: \(batteryLevel)%, device is plugged in."
      #if os(macOS) || targetEnvironment(macCatalyst)
      case .pluggedInNotCharging(let level):
        return "Battery level: \(level)%, device is plugged in and not charging."
      #endif
      case .full:
        #if os(macOS) || targetEnvironment(macCatalyst)
          return "Battery is charged, device is plugged in."
        #else
          return "Battery level: 100 % (Full), device is plugged in."
        #endif
      case .unplugged(let batteryLevel):
        return "Battery level: \(batteryLevel)%, device is unplugged."
      }
    }

  }

  /// The state of the battery
  @MainActor
  public var batteryState: BatteryState? {
    guard isCurrent else { return nil }
    #if os(macOS) || targetEnvironment(macCatalyst)
      return MacBatteryReading.current?.state
    #else
      #if os(iOS)
      // UIKit reports a synthetic battery for iOS apps running directly on a Mac.
      guard !DeviceHost.isIOSAppOnMac else { return nil }
      #endif
      return BatteryState(for: self)
    #endif
  }

  /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
  @MainActor
  public var batteryLevel: Int? {
    #if os(macOS) || targetEnvironment(macCatalyst)
      guard isCurrent else { return nil }
      return MacBatteryReading.current?.level
    #else
      switch batteryState {
      case nil: return nil
      case .charging(let value): return value
      case .full: return 100
      case .unplugged(let value): return value
      }
    #endif
  }

}

#if os(macOS) || targetEnvironment(macCatalyst)
struct MacBatteryReading {
  let state: Device.BatteryState?
  let level: Int

  init?(source: [String: Any]) {
    guard source[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
          let capacity = source[kIOPSCurrentCapacityKey] as? Int,
          let maximum = source[kIOPSMaxCapacityKey] as? Int, maximum > 0,
          (0...maximum).contains(capacity)
    else { return nil }

    level = Int((Double(capacity) * 100 / Double(maximum)).rounded())
    switch source[kIOPSPowerSourceStateKey] as? String {
    case kIOPSBatteryPowerValue:
      state = .unplugged(level)
    case kIOPSACPowerValue:
      // IOKit may consider a battery charged while its measured level is 95–99%.
      if source[kIOPSIsChargedKey] as? Bool == true {
        state = .full
      } else if let charging = source[kIOPSIsChargingKey] as? Bool {
        state = charging ? .charging(level) : .pluggedInNotCharging(level)
      } else {
        state = nil
      }
    default:
      state = nil
    }
  }

  static var current: Self? {
    guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
          let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef]
    else { return nil }
    for source in sources {
      if let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any],
         let reading = Self(source: info) {
        return reading
      }
    }
    return nil
  }
}
#endif

// MARK: Device.Batterystate: Comparable

extension Device.BatteryState: Comparable {
  /// Compares two battery states.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// Full sorts last. Equal percentages sort by state: unplugged, plugged in but not charging, then charging.
  public static func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    lhs.sortKey < rhs.sortKey
  }

  private var sortKey: (level: Int, state: Int) {
    switch self {
    case .unplugged(let level): (level, 0)
    #if os(macOS) || targetEnvironment(macCatalyst)
    case .pluggedInNotCharging(let level): (level, 1)
    #endif
    case .charging(let level): (level, 2)
    case .full: (.max, 3)
    }
  }
}
#endif
