# SwiftDeviceKit

A dependency-free device catalog and runtime utilities for **iOS / iPadOS 18+**.
Built with **Swift tools 6.4**, **Swift 6 language mode**, and **Xcode 27** or newer.

## Installation

Add `https://github.com/Anywhere-Music-Player/SwiftDeviceKit` in Xcode's package
dependencies and select the product you need. Until the first tagged release,
select a reviewed commit or the `main` branch.

| Product / module | Contents | Dependencies |
| --- | --- | --- |
| `SwiftDeviceKitCore` | Model identification, current device, simulator/preview detection and hardware catalog | System Foundation/Darwin |
| `SwiftDeviceKitSystem` | Core plus battery, thermal state, storage and UIKit-backed device state | Core and system Foundation/UIKit |

Both products share one package version and have no external package dependencies.
System depends on Core; Core does not depend on System. Selecting only the Core
product excludes the System target and its privacy manifest from that dependency.
The old `SwiftDeviceKit` product/module has been replaced by these two products.

```swift
import SwiftDeviceKitCore

let device = Device.current
print(device.realDevice.description)
print(device.hasDynamicIsland)
print(device.hasUSBCConnectivity)
```

## Scope

- Two Swift modules in one package, with no external package dependencies.
- A catalog of 66 models (37 iPhones and 29 iPads), including iPhone Duo,
  with 105 hardware identifiers. Only models supporting iOS/iPadOS 18 or later are included.
- Model identifiers, names, display specifications, cameras, CPU, biometrics,
  Apple Pencil support and capability groups.
- Simulator and SwiftUI preview detection, battery, orientation, thermal state,
  screen information and disk capacity utilities.
- SwiftPM distribution only. No CocoaPods, Carthage, example application,
  watchOS/tvOS implementation or pre-iOS-18 compatibility branches.

The oldest supported families are iPhone XS/XS Max/XR, iPhone SE (2nd generation),
iPad (7th generation), iPad mini (5th generation), iPad Air (3rd generation),
iPad Pro 11-inch (1st generation) and iPad Pro 12.9-inch (3rd generation).
The cutoff follows Apple's [iOS 18 compatibility list](https://support.apple.com/en-nz/104985)
and [iPadOS 18 announcement](https://www.apple.com/ie/newsroom/2024/09/ipados-18-is-now-available-taking-ipad-to-the-next-level/).
Models introduced with newer OS versions are included too. Older hardware,
iPods and HomePod are outside the catalog; their identifiers resolve to `.unknown(identifier)`.

The catalog consists of typed Swift records, with one file per model. It requires
no code generator, Python, JSON loading or extra build step. Test fixtures are not
included in the library target. Using model identification does
not start battery monitoring. Battery monitoring is enabled only while querying
battery state and then restored. Disk APIs retain the upstream privacy manifest;
the consuming app must use those APIs for an applicable declared reason.

The split gives consumers an explicit dependency boundary. It does not promise a
smaller app binary or faster builds; measure the optimized consuming app first.
Core has no resource bundle. The disk-space privacy manifest belongs to System.

## Migration from DeviceKit

For catalog-only usage, replace `import DeviceKit` (or the earlier
`import SwiftDeviceKit`) with `import SwiftDeviceKitCore`. For system-state APIs,
select the System product and use `import SwiftDeviceKitSystem`. System exposes
`Device` as a public type alias of the Core type: it is the same value, and one
System import gives access to both catalog and system APIs. For supported models, the
`Device` cases and model names retain their exact spelling. Cases for hardware
that cannot run iOS/iPadOS 18 are removed, along with `isPod`, `allPods`,
`allSimulatorPods` and CPU cases used only by removed models. Update references
to those APIs when migrating; `allRealDevices` now contains only iPhones and iPads.

`Device` and its associated value types are `Sendable`. Catalog lookup, model
names, `Device.current` and `isCanvas` are in Core and can be used outside the
main actor. UIKit-backed properties live in System and require `@MainActor`:
`isPhone`, `isPad`, device/OS names, battery, orientation, brightness, zoom and
Guided Access. `isPhone` and `isPad` retain
their UIKit fallback for a current model that is not yet in the catalog. In Core,
use `Device.allPhones.contains(device.realDevice)` or `Device.allPads` for known
catalog-family membership without UIKit.

```swift
import SwiftDeviceKitSystem

@MainActor
func batteryDescription() -> String? {
    Device.current.batteryState?.description
}
```

`Device.identifier` is now immutable. For custom input, call
`Device.mapToDevice(identifier:)` instead of changing global state.
Simulator detection also recognizes `.simulator(.unknown(...))`. Simulator camera
metadata describes its catalog model, not cameras physically available to the simulator.
Inherited deprecated aliases remain available; this package does not add new
compatibility shims or claim complete source compatibility with DeviceKit.

## Catalog structure

Each model is an immutable `DeviceDefinition` value declared in an extension.
Models share the same typed fields; they do not subclass one another.

```text
Sources/SwiftDeviceKitCore/
  Device.swift                         Public Device cases
  Catalog/
    DeviceDefinition.swift             Shared record fields and capabilities
    DeviceCatalog.swift                Registration and case-to-record mapping
    Device+Catalog.swift               Queries and capability groups
    iPhone/iPhone18Pro.swift            One model's IDs and specifications
    iPhone/iPhoneDuo.swift              Duo, including both display records
    iPad/                              One file per iPad model
  Hardware/                            Screen, CPU, camera and Pencil value types
  Device+Current.swift                 Identity, simulator and preview detection
Sources/SwiftDeviceKitSystem/
  Device.swift                         Public alias of Core's Device
  Device+System.swift                   UIKit-backed device properties
  Device+Battery.swift                 Battery state
  Device+ThermalState.swift             Thermal state
  Device+Storage.swift                  Disk capacity
  Device+ScreenState.swift              Existing orientation, brightness and zoom APIs
  PrivacyInfo.xcprivacy                 Disk-space API declarations
```

Identifiers, names, screens and capabilities are defined only in the model record.
For example, `Catalog/iPhone/iPhone18Pro.swift` contains:

```swift
extension DeviceDefinition {
  static let iPhone18Pro = DeviceDefinition(
    model: .iPhone18Pro, family: .phone,
    name: "iPhone 18 Pro",
    identifiers: ["iPhone19,2"],
    cpu: .a20Pro,
    capabilities: [
      .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland,
      .wirelessCharging, .fiveG, .eSIM, .dualESIM, .lidar, .usbC,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.3, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
```

The public `Device` remains an enum so existing cases and pattern matching stay
available. A central registry is explicit: Swift does not discover extension
records by scanning source files at runtime. Capability groups are derived from
the registered records, and identifier lookup uses an immutable index.

## Adding a model

1. Add the public case to `Device.swift`.
2. Add a model file under the appropriate `Catalog/` family, using named fields
   and verified identifiers/specifications. Reuse existing hardware types where applicable.
3. Register the record in `DeviceCatalog.all` and map the new case in
   `Device.definition`, both in `Catalog/DeviceCatalog.swift`. Preserve existing
   catalog order; the exhaustive switch reports missing case mappings at compile time.
4. Add regression coverage for the identifiers and relevant capabilities. Run the
   simulator tests below. Keep frozen fixtures unchanged; extend tests deliberately
   when adding a model to an existing public group.

No generation command is needed. SwiftPM includes the model files directly.

## Display specifications

Use `screens` to enumerate built-in panels, or select one by role:

```swift
let duo = Device.mapToDevice(identifier: "iPhone19,4")
let outer = duo.screen(.outer)
let inner = duo.screen(.inner)

print(outer?.diagonal)          // 5.4 inches
print(inner?.ppi)               // 430
print(inner?.resolution?.width) // 1878 pixels
print(duo.screens.count)        // 2
```

The screen values are immutable, `Sendable` and `Hashable`, and can be read outside
the main actor. `screen(_:)` returns `nil` when the requested role is absent.
Single-screen iPhones and iPads expose one `.main` screen with their existing
diagonal, PPI and aspect ratio. Their `resolution` is currently `nil` because the
catalog does not contain verified pixel dimensions for those models. Unknown
models have an empty `screens` array.

iPhone Duo has two panels, listed in stable outer-then-inner order. Values come
from [Apple's technical specifications](https://www.apple.com/iphone-duo/specs/),
verified on 21 October 2026:

| Panel | Diagonal | Resolution (pixels) | PPI | Width:height ratio |
| --- | --- | --- | --- | --- |
| `.outer` | 5.4 inches | 1398 × 2034 | 460 | 233:339 |
| `.inner` | 7.6 inches | 1878 × 2670 | 430 | 313:445 |

Ratios are reduced from the published pixel dimensions. Diagonals are advertised
sizes; rounded corners reduce the viewable area. Both panels have non-nil
resolutions. The existing `Device.diagonal`, `ppi` and `screenRatio` always describe
the **outer** panel for Duo; they no longer return unspecified values for this model.

These are static hardware specifications. They do not determine the current fold
state, active panel, orientation, window bounds or external displays. Use the
current view's geometry for layout. Simulator wrappers return the same catalog
specifications as their hardware model.

## Validation

Every catalog model is data, so testing all models does **not** require booting a
simulator for each one. The Core tests feed all 105 supported identifiers into
`mapToDevice`, compare the 65 retained donor models against the frozen DeviceKit
5.9.0 fixture, and verify the added Duo model against its explicit specification.
They also check the 67 excluded identifiers, all supported model records, capability
groups, CPU/camera/Pencil metadata, screen records and simulator wrappers.

The frozen fixtures are test resources, never shipped in either library product.
Keep them unchanged when refactoring. They check compatibility with the donor;
they cannot prove that the donor's hardware data was correct. New or corrected
specifications need separate Apple-source assertions, as Duo's panels do.

The test targets have separate dependencies: Core tests depend only on Core;
System tests import only System and verify its Core type alias plus runtime APIs.
Simulator identifier resolution is also tested with explicit environment input,
including future models and malformed values, without changing process globals.

Use Xcode 27 with Swift tools 6.4 and one available iPhone simulator. To run both
suites, use the package scheme shown by `xcodebuild -list`:

```sh
xcodebuild test -scheme SwiftDeviceKit-Package \
  -destination 'platform=iOS Simulator,id=<SIMULATOR-UUID>' \
  -derivedDataPath "$HOME/Library/Developer/Xcode/DerivedData/SwiftDeviceKit" \
  -parallel-testing-enabled NO
```

A practical validation matrix is:

| Check | When / where |
| --- | --- |
| All catalog and System tests | Each change, one current iPhone simulator |
| UIKit iPad idiom and iPadOS naming | One iPad simulator on the same runtime |
| Minimum-OS behavior | iOS 18 simulator or device when available, especially before a release |
| Battery/Low Power Mode, brightness, orientation, thermal and storage behavior | A real iPhone or iPad before a release affecting those APIs |
| Core-only dependency boundary | Build a consumer selecting only Core; System and its resource bundle must be absent |

One simulator runtime can host multiple device profiles; installing a runtime for
every catalog model is unnecessary. Catalog checks are deterministic unit tests,
not merely a static source scan. A successful build verifies Swift types, access
control and deployment-target declarations, but does not execute the code on iOS 18.
Simulator results do not establish physical sensor or battery behavior; see
[Apple's guidance on simulated and physical devices](https://developer.apple.com/documentation/Xcode/running-your-app-on-simulated-or-physical-devices).

Window size, safe areas, layout, active scenes and fold-driven UI changes belong to
the consuming SwiftUI app. This package supplies static panel specifications and
adds no views, active-panel detector or UI-monitoring service.

See [CHANGELOG.md](CHANGELOG.md), [ATTRIBUTION.md](ATTRIBUTION.md) and [LICENSE](LICENSE).
