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
- The complete upstream iOS catalog (99 models), plus iPhone Duo.
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

## iPhone Duo

`iPhone19,4` maps to `.iPhoneDuo`; `isFoldable` also works on its simulator wrapper.
The identifier and foldability were adapted from Zandor Smith's
[DeviceKit #507](https://github.com/devicekit/DeviceKit/pull/507), pinned at
`1b48a59b0fe0c93ccf2db5392957bc5615ae5068`.
The locally installed Apple CoreSimulator profile `iPhone Duo.simdevicetype`,
version 405, independently identifies the model as `iPhone19,4`.

Capabilities were checked against [Apple's technical specifications](https://www.apple.com/iphone-duo/specs/)
on 21 October 2026: A20 Pro, Touch ID, Dynamic Island, rounded corners, USB-C,
wireless charging, 5G, dual eSIM, USB-C Apple Pencil, and wide/ultra-wide cameras.
An optical-quality crop is not treated as a separate telephoto camera.
The imported PR's unconfirmed capability defaults were updated from this source.

The model has two displays:

| Panel | Diagonal | Pixels | PPI |
| --- | --- | --- | --- |
| Outer | 5.4 inches | 1398 × 2034 | 460 |
| Inner | 7.6 inches | 1878 × 2670 | 430 |

The installed simulator profile describes the inner panel as 2007 × 2853 at 460 PPI;
it therefore must not be used as the authoritative hardware specification.
`diagonal` and `screenRatio` return the existing unknown sentinel `-1`, and `ppi`
returns `nil` for Duo, because the current scalar API does not identify a panel.
These values do not mean that Apple's specifications are unknown. A future API
can represent both panels explicitly. For layout, use the current view's geometry.

Validation uses catalog lookups on an iPhone 17 Pro simulator. No Duo simulator
or physical Duo is required to exercise the identifier mapping; those tests do
not verify folding transitions or real hardware behavior. Other upstream PRs
remain separate work.

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
