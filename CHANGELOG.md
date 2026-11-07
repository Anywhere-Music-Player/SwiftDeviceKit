# Changelog

## Unreleased

- Refresh disk-capacity measurements between synchronous reads.

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
