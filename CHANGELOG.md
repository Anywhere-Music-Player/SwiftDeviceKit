# Changelog

## 2026.2.0 — 2026-11-07

- Preserve the iPhone-only membership and order of deprecated `allXSeriesDevices` when migrating to `allPhonesWithSensorHousing`.
- Read the Mac battery through IOKit in Mac Catalyst, including the `BatteryState.pluggedInNotCharging(Int)` case. Designed for iPad/iPhone apps on Mac return `nil` for battery readings. An unavailable battery reading in an iPad app on a Vision simulator also returns `nil`.
- On iOS and Mac Catalyst, `screenBrightness` now returns `Int?`. Unwrap the percentage before display. UIKit readings outside 0...1 return `nil`.
- On iPhone and iPad, use `Device.beginOrientationUpdates()` and `Device.endOrientationUpdates()` to start and stop physical orientation notifications.
- Add Apple Watch (watchOS 11), Apple TV (tvOS 18), native Mac (macOS 15) and Apple Vision Pro (visionOS 2) to Core and System. The shared catalog covers all six device families on each platform.
- Report the visionOS host in Designed for iPad or iPhone apps. Handle the new `Device.unidentifiedVision(reportedIdentifier:)` case when the OS identifies a headset but masks its hardware model.
- Add `Device.Family`, new cases in `Device`, `Device.CPU` and `Device.CameraType`, and spatial display specifications for Vision Pro. Update exhaustive switches when migrating.
- Correct the 2024 Mac mini chip identifiers and limit simulator groups to models with simulator runtimes.
- Return 64-bit storage byte counts on watchOS and preserve the measured battery percentage on Mac. Unknown battery readings on physical iPhones, iPads and watches return `nil`.
- On macOS, handle the new `BatteryState.pluggedInNotCharging(Int)` case in exhaustive switches. It reports external power with charging paused.
- Expose Low Power Mode through `Device.current.isLowPowerModeEnabled`, including on Macs without an internal battery.
- Add `hasActionButton` and `Device.allDevicesWithActionButton` for models with a customizable Action button.
- Add `hasVariableAperture` and `Device.allDevicesWithVariableAperture` for models with a variable-aperture camera lens.

## 2026.1.1 — 2026-11-07

- Keep a known iPad classified as an iPad when it runs an iPhone-only app. [#9](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/9)
- Report the Mac hardware identifier and macOS version when an iOS app runs directly on Apple silicon. [#10](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/10)
- Correct the 13-inch iPad Pro (M5) specifications link and use locale-neutral Apple Support links for the affected iPads. [#11](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/11)

## 2026.1.0 — 2026-11-07

- Refresh disk-capacity measurements between synchronous reads.
- Correct 3x display-scale zoom detection and remove the unsupported legacy Plus heuristic.
- Use structural device identity, preserving unknown identifiers even when they match display names.
- Correct M5 iPad Pro Pencil compatibility and normalize nine iPad screen ratios to portrait.
- Give battery states a total ordering with deterministic equal-percentage ties.
- Preserve all catalog capabilities and family classification through nested simulator wrappers.
- Add iPad mini (A20 Pro), with two verified identifiers and documented screen specifications.
- Add regression coverage and explicit comparison allowances without changing frozen donor fixtures.

## 2026.0.0 — 2026-10-21

Initial release of SwiftDeviceKit, based on DeviceKit.

- Support iOS / iPadOS 18+ with Swift tools 6.4 and Swift 6 language mode.
- Provide two modules with no external dependencies: `SwiftDeviceKitCore` for
  device identification and hardware data, and `SwiftDeviceKitSystem` for Core
  plus runtime utilities.
- Include 66 iPhone and iPad models with 105 hardware identifiers.
- Define the catalog entirely in Swift, with one file per device and shared
  indexes and capability groups.
- Use `Sendable` device and hardware values, immutable identity and
  `@MainActor` isolation for UIKit-backed APIs.
- Identify iPhone Duo and expose specifications for both of its screens.
- Return model camera metadata for simulator wrappers and recognize simulators
  of unknown devices.
- Provide battery, thermal state, storage, orientation, brightness and system
  information through the System module.
- Include catalog and System tests, plus an optional standalone comparison
  against the original DeviceKit.
- Document module usage, migration, screens and adding new devices.

Source history and acknowledgments are recorded in [ATTRIBUTION.md](ATTRIBUTION.md).
