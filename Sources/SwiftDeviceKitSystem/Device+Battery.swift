// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
import Foundation
#if os(macOS)
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
   - Charging:  The device is plugged into power and the battery is less than 100% charged.
   - Unplugged: The device is not plugged into power; the battery is discharging.
   */
  public enum BatteryState: CustomStringConvertible, Equatable, Sendable {
    /// The OS reports the battery as charged. On Mac, batteryLevel can still be below 100%.
    case full
    /// The device is plugged into power and the battery is less than 100% charged.
    /// The associated value is in percent (0-100).
    case charging(Int)
    /// The device is not plugged into power; the battery is discharging.
    /// The associated value is in percent (0-100).
    case unplugged(Int)

    #if !os(macOS)
    #if os(watchOS)
    typealias ReportedState = WKInterfaceDeviceBatteryState
    #else
    typealias ReportedState = UIDevice.BatteryState
    #endif

    @MainActor
    fileprivate init?() {
      #if os(watchOS)
        let device = WKInterfaceDevice.current()
      #else
        let device = UIDevice.current
      #endif
      let previous = device.isBatteryMonitoringEnabled
      device.isBatteryMonitoringEnabled = true
      defer { device.isBatteryMonitoringEnabled = previous }
      #if targetEnvironment(simulator)
        let isSimulator = true
      #else
        let isSimulator = false
      #endif
      self.init(reportedState: device.batteryState, level: device.batteryLevel, isSimulator: isSimulator)
    }

    init?(reportedState: ReportedState, level: Float, isSimulator: Bool) {
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
          guard isSimulator else { return nil }
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
      case .full:
        #if os(macOS)
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
    #if os(macOS)
      return MacBatteryReading.current?.state
    #else
      return BatteryState()
    #endif
  }

  /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
  @MainActor
  public var batteryLevel: Int? {
    #if os(macOS)
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

#if os(macOS)
struct MacBatteryReading {
  let state: Device.BatteryState
  let level: Int

  init?(source: [String: Any]) {
    guard source[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
          let capacity = source[kIOPSCurrentCapacityKey] as? Int,
          let maximum = source[kIOPSMaxCapacityKey] as? Int, maximum > 0,
          (0...maximum).contains(capacity)
    else { return nil }

    level = Int((Double(capacity) * 100 / Double(maximum)).rounded())
    if source[kIOPSPowerSourceStateKey] as? String == kIOPSBatteryPowerValue {
      state = .unplugged(level)
    } else if source[kIOPSIsChargedKey] as? Bool == true {
      // IOKit may consider a battery charged while its measured level is 95–99%.
      state = .full
    } else {
      state = .charging(level)
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
  /// Full sorts last. Otherwise compare charge percentages, with unplugged before charging
  /// at the same percentage. Equality retains both the state and its associated percentage.
  public static func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    switch (lhs, rhs) {
    case (.full, _): return false  // return false (even if both are `.Full` -> they are equal)
    case (_, .full): return true  // lhs is *not* `.Full`, rhs is
    case (.charging(let lhsLevel), .charging(let rhsLevel)): return lhsLevel < rhsLevel
    case (.charging(let lhsLevel), .unplugged(let rhsLevel)): return lhsLevel < rhsLevel
    case (.unplugged(let lhsLevel), .charging(let rhsLevel)): return lhsLevel <= rhsLevel
    case (.unplugged(let lhsLevel), .unplugged(let rhsLevel)): return lhsLevel < rhsLevel
    }
  }
}
#endif
