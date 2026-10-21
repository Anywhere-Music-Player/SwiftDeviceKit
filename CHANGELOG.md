# Changelog

## Unreleased

- Establish SwiftDeviceKit from DeviceKit 5.9.0 with its MIT attribution.
- Require iOS/iPadOS 18+, Swift tools 6.4 and Swift 6 language mode.
- Provide dependency-free `SwiftDeviceKitCore` and `SwiftDeviceKitSystem` products;
  System depends on Core. Remove other platform implementations,
  obsolete Swift/OS compatibility branches and alternate distribution tooling.
- Make device identity immutable, value types Sendable and UIKit access MainActor-isolated.
- Restrict the catalog to 66 iPhone/iPad models supporting iOS/iPadOS 18 or later;
  preserve the exact names and metadata of retained models.
- Remove 34 older or out-of-scope models, iPod-only APIs and unused CPU cases.
  Their 67 identifiers now resolve to unknown; 105 supported identifiers remain.
- Recognize simulators whose models are not yet in the catalog.
- Forward simulator camera metadata to its catalog model, matching other capabilities.
- Replace Python/GYB generation with typed Swift definitions, one file per model.
- Split the catalog, hardware value types and runtime utilities into focused files.
- Derive capability groups and the identifier index from the registered records.
- Keep the frozen 5.9.0 baseline and verify retained hardware metadata and group
  ordering against a snapshot captured before the Swift catalog migration.
- Test excluded identifiers and the oldest supported iPhone/iPad generations.
- Add iPhone Duo identification and foldability from DeviceKit #507, with capabilities
  checked against Apple specifications and identity checked against its simulator profile.
- Expose immutable, Sendable screen records through `screens` and `screen(_:)`,
  including both Duo panels' Apple-published diagonal, pixel resolution, PPI and ratio.
- Use Duo's outer panel for scalar display metrics, independently of fold state.
- Move source provenance from the README introduction to `ATTRIBUTION.md`;
  retain the MIT license and original copyright notices.
- Keep model identity, simulator/preview detection and catalog types in Core without UIKit.
- Move UIKit-backed state and the disk-space privacy manifest into System; expose
  the same Core Device type through a public alias.
- Split catalog and System test targets, and document validation without a simulator
  for each catalog model. Reject recursive malformed simulator environment values.
- Keep active-panel detection and SwiftUI layout outside the package.
- Defer unrelated upstream pull requests.
