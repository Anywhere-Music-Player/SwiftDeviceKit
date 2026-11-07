# Display specifications

Use `screens` to enumerate built-in panels, or select one by role:

```swift
import SwiftDeviceKitCore

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
Single-screen iPhones and iPads expose one `.main` screen. All ratios and pixel
dimensions use portrait reference orientation (width <= height), independently
of UI rotation. iPad mini (A20 Pro) has a verified 1512 × 2316 resolution and
126:193 ratio; other single-screen models retain `nil` resolution until verified
pixel dimensions are added. Unknown models have an empty `screens` array.

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
the **outer** panel for Duo; these scalar properties do not switch with the active panel.

These are static hardware specifications. They do not determine the current fold
state, active panel, orientation, window bounds or external displays. Use the
current view's geometry for layout. Simulator wrappers return the same catalog
specifications as their hardware model.

See [catalog corrections](CatalogCorrections.md) for the nine normalized iPad
ratios and the sources for iPad mini (A20 Pro).

[Back to README](../README.md)
