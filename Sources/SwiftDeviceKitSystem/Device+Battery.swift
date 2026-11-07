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

   - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
   - Charging:  The device is plugged into power and the battery is less than 100% charged.
   - Unplugged: The device is not plugged into power; the battery is discharging.
   */
  public enum BatteryState: CustomStringConvertible, Equatable, Sendable {
    /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
    case full
    /// The device is plugged into power and the battery is less than 100% charged.
    /// The associated value is in percent (0-100).
    case charging(Int)
    /// The device is not plugged into power; the battery is discharging.
    /// The associated value is in percent (0-100).
    case unplugged(Int)

    @MainActor
    fileprivate init?() {
      #if os(macOS)
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef]
        else { return nil }
        for source in sources {
          guard let info = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue()
                  as? [String: Any],
                info[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
                let capacity = info[kIOPSCurrentCapacityKey] as? Int,
                let maximum = info[kIOPSMaxCapacityKey] as? Int, maximum > 0
          else { continue }
          let percent = Int((Double(capacity) * 100 / Double(maximum)).rounded())
          if info[kIOPSPowerSourceStateKey] as? String == kIOPSBatteryPowerValue {
            self = .unplugged(percent)
          } else if info[kIOPSIsChargedKey] as? Bool == true {
            self = .full
          } else {
            // BatteryState describes external power, including optimized charging holds.
            self = .charging(percent)
          }
          return
        }
        return nil
      #else
        #if os(watchOS)
          let device = WKInterfaceDevice.current()
        #else
          let device = UIDevice.current
        #endif
        let previous = device.isBatteryMonitoringEnabled
        device.isBatteryMonitoringEnabled = true
        defer { device.isBatteryMonitoringEnabled = previous }
        let percent = Int((device.batteryLevel * 100).rounded())
        switch device.batteryState {
        case .charging: self = .charging(percent)
        case .unplugged: self = .unplugged(percent)
        case .full: self = .full
        case .unknown:
          #if os(visionOS)
            return nil
          #else
            self = .full  // DeviceKit compatibility on iOS and watchOS simulators.
          #endif
        @unknown default: return nil
        }
      #endif
    }

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
      case .full: return "Battery level: 100 % (Full), device is plugged in."
      case .unplugged(let batteryLevel):
        return "Battery level: \(batteryLevel)%, device is unplugged."
      }
    }

  }

  /// The state of the battery
  @MainActor
  public var batteryState: BatteryState? {
    guard isCurrent else { return nil }
    return BatteryState()
  }

  /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
  @MainActor
  public var batteryLevel: Int? {
    switch batteryState {
    case nil: return nil
    case .charging(let value): return value
    case .full: return 100
    case .unplugged(let value): return value
    }
  }

}

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
