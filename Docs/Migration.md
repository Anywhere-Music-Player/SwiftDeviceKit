# Migrating from DeviceKit

Select the product that matches your usage:

| DeviceKit usage | SwiftDeviceKit product |
| --- | --- |
| Model identity and hardware capabilities | `SwiftDeviceKitCore` |
| Battery, storage, thermal state and UIKit-backed properties | `SwiftDeviceKitSystem` |

For catalog-only usage, replace `import DeviceKit` with `import SwiftDeviceKitCore`. For system-state APIs,
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

## Supported models

The catalog includes iPhone and iPad models supporting iOS/iPadOS 18 or later.
Its oldest families are iPhone XS/XS Max/XR, iPhone SE (2nd generation),
iPad (7th generation), iPad mini (5th generation), iPad Air (3rd generation),
iPad Pro 11-inch (1st generation) and iPad Pro 12.9-inch (3rd generation).

The cutoff follows Apple's [iOS 18 compatibility list](https://support.apple.com/en-nz/104985)
and [iPadOS 18 announcement](https://www.apple.com/ie/newsroom/2024/09/ipados-18-is-now-available-taking-ipad-to-the-next-level/).
Models introduced with newer OS versions are included too. Older hardware,
iPods and HomePod resolve to `.unknown(identifier)`.

## Corrections after 2026.0.0

- `Device` equality compares enum cases and associated values, not descriptions.
  An unknown identifier matching a model name no longer acquires its capabilities
  or passes the current-device guard.
- Nested simulator wrappers fully unwrap through `realDevice` and expose the
  underlying catalog capabilities and phone/pad family at every depth.
- Screen ratios consistently use portrait orientation; M5 iPad Pro no longer
  advertises second-generation Pencil support. See [catalog corrections](CatalogCorrections.md).
- Battery ordering compares percentages, then places unplugged before charging
  at equal percentages; full remains last. Different charging states stay unequal.
- Every disk-capacity query starts with a fresh URL resource cache.
- `isZoomed` uses `nativeScale > scale` for the supported iOS 18+ catalog. Standard
  mini downsampling and iPad More Space are not enlarged modes. The removed
  legacy Plus heuristic applied to unsupported 1080p Plus models. This API does
  not detect Accessibility Zoom; use view geometry for layout decisions.

## System resources

Core has no resource bundle. System includes the disk-space privacy manifest.
Applications using those APIs must use them for an applicable declared reason.

Model identification does not enable battery monitoring. Battery queries
temporarily enable monitoring, read the state and restore the previous setting.

[Back to README](../README.md)
