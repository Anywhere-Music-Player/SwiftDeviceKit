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
- Add iPhone Duo identification and foldability from DeviceKit #507, with capabilities
  checked against Apple specifications and identity checked against its simulator profile.
- Document both Duo displays and retain unspecified scalar metrics until the API
  can represent separate panels; no active-display guess is made.
- Defer optional module separation and unrelated upstream pull requests.
