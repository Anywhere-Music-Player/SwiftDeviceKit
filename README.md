# SwiftDeviceKit

A dependency-free device catalog and runtime utilities for **iOS / iPadOS 18+**.
Built with **Swift tools 6.4**, **Swift 6 language mode**, and **Xcode 27** or newer.

Derived from [DeviceKit 5.9.0](https://github.com/devicekit/DeviceKit/releases/tag/5.9.0),
commit `19528aa07e1426626ea9fb2c4a161edf43c4f9e8` (22 September 2026).
The original MIT license and copyright notices are retained.

## Installation

Add `https://github.com/Anywhere-Music-Player/SwiftDeviceKit` in Xcode's package
dependencies and select the `SwiftDeviceKit` product. Until the first tagged
release, select a reviewed commit or the `main` branch.

```swift
import SwiftDeviceKit

let device = Device.current
print(device.realDevice.description)
print(device.hasDynamicIsland)
print(device.hasUSBCConnectivity)
```

## Scope

- One Swift module and no external package dependencies.
- The complete upstream iOS catalog: 99 iPhone, iPad, iPod and HomePod models.
  Old model records are retained for explicit lookups; running on old iOS is unsupported.
- Model identifiers, names, display specifications, cameras, CPU, biometrics,
  Apple Pencil support and capability groups.
- Simulator and SwiftUI preview detection, battery, orientation, thermal state,
  screen information and disk capacity utilities.
- SwiftPM distribution only. No CocoaPods, Carthage, example application,
  watchOS/tvOS implementation or pre-iOS-18 compatibility branches.

The catalog is generated from one checked-in template. The generator and test
fixtures are not included in the library target. Using model identification does
not start battery monitoring. Battery monitoring is enabled only while querying
battery state and then restored. Disk APIs retain the upstream privacy manifest;
the consuming app must use those APIs for an applicable declared reason.

Separate products for catalog and runtime utilities are deferred until a measured
consumer benefit justifies a larger public API. A module split is not a promise of
a smaller app binary; measure the optimized app and build times first.

## Migration from DeviceKit

Change `import DeviceKit` to `import SwiftDeviceKit`. The `Device` cases and model
names are preserved, including their exact display spelling.

`Device` and its associated value types are `Sendable`. Catalog lookup, model
names and `Device.current` can be used outside the main actor. UIKit-backed
properties require `@MainActor`: `isPhone`, `isPad`, device/OS names, battery,
orientation, brightness, zoom and Guided Access. `isPhone` and `isPad` retain
their UIKit fallback for a current model that is not yet in the catalog.

```swift
@MainActor
func batteryDescription() -> String? {
    Device.current.batteryState?.description
}
```

`Device.identifier` is now immutable. For custom input, call
`Device.mapToDevice(identifier:)` instead of changing global state.
Simulator detection also recognizes `.simulator(.unknown(...))`.
Inherited deprecated aliases remain available; this package does not add new
compatibility shims or claim complete source compatibility with DeviceKit.

## Updating the catalog

1. Edit `Tools/Device.swift.gyb`, preserving verified identifiers and source evidence.
2. Run `python3 Tools/generate.py` using Xcode 27's toolchain.
3. Run `python3 Tools/generate.py --check` and the simulator tests.
4. Add a model regression test. Keep the frozen 5.9.0 baseline fixture unchanged.
5. Review the diff, then publish a tested semantic-version tag when ready.

New-device pull requests, including
[DeviceKit #507](https://github.com/devicekit/DeviceKit/pull/507), are **not imported**
in this initial cleanup. Unverified identifiers continue to return `.unknown`.
The initial catalog includes the iPhone 18 Pro / Pro Max records already released
in DeviceKit 5.9.0.

## Validation

Use a free iOS simulator with a current runtime, and an external build directory:

```sh
python3 Tools/generate.py --check
xcodebuild test -scheme SwiftDeviceKit \
  -destination 'platform=iOS Simulator,id=<SIMULATOR-UUID>' \
  -derivedDataPath "$HOME/Library/Developer/Xcode/DerivedData/SwiftDeviceKit" \
  -parallel-testing-enabled NO
```

The tests retain the upstream iOS suite and add a frozen catalog baseline,
unknown-device/simulator checks, runtime guards and a Swift concurrency check.
Simulator tests do not prove physical battery or screen sensor behavior.

See [CHANGELOG.md](CHANGELOG.md) for changes and [LICENSE](LICENSE) for the MIT license.
