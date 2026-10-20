# Changelog

## Unreleased

- Establish SwiftDeviceKit from DeviceKit 5.9.0 with its MIT attribution.
- Require iOS/iPadOS 18+, Swift tools 6.4 and Swift 6 language mode.
- Keep one dependency-free SwiftPM product; remove other platform implementations,
  obsolete Swift/OS compatibility branches and alternate distribution tooling.
- Make device identity immutable, value types Sendable and UIKit access MainActor-isolated.
- Preserve the upstream iOS model catalog and exact display names.
- Recognize simulators whose models are not yet in the catalog.
- Keep reproducible catalog generation and add a frozen 5.9.0 regression baseline.
- Defer new-device pull requests and optional module separation.
