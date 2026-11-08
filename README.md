<p align="center">
  <img src="SwiftDeviceKit.svg" width="112" height="112" alt="SwiftDeviceKit icon">
</p>
<h1 align="center">SwiftDeviceKit</h1>
<p align="center">
  <a href="Package.swift"><img src="https://img.shields.io/badge/Swift_tools-6.4%2B-F05138" alt="Swift tools 6.4+"></a>
  <a href="#requirements"><img src="https://img.shields.io/badge/platforms-iOS_%C2%B7_iPadOS_%C2%B7_watchOS_%C2%B7_tvOS_%C2%B7_macOS_%C2%B7_visionOS-2463A2" alt="iOS, iPadOS, watchOS, tvOS, macOS and visionOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT license"></a>
</p>

SwiftDeviceKit identifies the iPhone, iPad, Apple Watch, Apple TV, Mac or Apple Vision Pro running your app. Based on [DeviceKit](https://github.com/devicekit/DeviceKit), it brings all six device families into one Swift catalog. An iPhone app can read Apple Watch specifications, and a native Mac app can identify its host and read its battery level when available.

Choose **SwiftDeviceKitCore** for the hardware catalog without UIKit. Choose **SwiftDeviceKitSystem** when you also need live readings. System includes every Core feature through the same `Device` type.

## DeviceKit 5.10.0 vs SwiftDeviceKit 2026.2.0

SwiftDeviceKit focuses on the hardware modern apps can run on. Its catalog counts **173 models across six Apple device families**, each capable of running the package’s minimum OS for its platform or a newer release. For an app targeting iOS 18, `Device.allPhones` already gives you the compatible iPhones, with older generations filtered out. [Minimum OS by platform](#requirements)

In our tests, the SwiftDeviceKit development build identified the Mac running an iPad app, distinguished the 40 mm and 44 mm Apple Watch SE 3 models, and reported the updated free space after a file write. [Tested commit `17f99f1`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/17f99f17fd78b2730ecae0c1afcce3ef711c8a5c)

DeviceKit issues marked **Open** were checked on 8 November 2026. The last column links to the change shipped in SwiftDeviceKit.

| Scenario | DeviceKit 5.10.0 | SwiftDeviceKit 2026.2.0 | Report or evidence | SwiftDeviceKit fix |
| --- | --- | --- | --- | --- |
| iPad app on a MacBook Pro | ❌ `iPad8,6` · iPadOS | ✅ `MacBookPro18,3` · macOS | [DeviceKit #506](https://github.com/devicekit/DeviceKit/issues/506) · Open | [61a13c8](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/61a13c8a0a2d383eb11e0268d5cf11de099cf7ec) |
| iPhone-only app on an iPad | ❌ Both `isPhone` and `isPad` are true | ✅ Only `isPad` is true | [DeviceKit #447](https://github.com/devicekit/DeviceKit/issues/447) · Open | [8daaaa9](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/8daaaa97d29916d9446780e0059332138888e90c) |
| Apple Pencil on iPad Pro M5 | ❌ Includes Pencil (2nd generation) | ✅ Pencil Pro and USB-C | [DeviceKit #504](https://github.com/devicekit/DeviceKit/issues/504) · Open | [a066b86](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/a066b86e1585043b910bd8eb5113cd1f8b130a32) |
| 11-inch iPad Pro (M4 or M5) screen ratio in portrait | ❌ 605:417 | ✅ 417:605 in portrait | [DeviceKit #433](https://github.com/devicekit/DeviceKit/issues/433) · Open (M4) | [887a59f](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/887a59f8f92b224c000758c88932693d37d5050b) |
| Watch SE 3 case size (`Watch7,14` / `Watch7,15`) | ❌ 40 mm / 44 mm | ✅ 44 mm / 40 mm, matching Apple’s profiles | [Measurements](Docs/DeviceKitComparison.md#where-did-the-answers-differ) | [f40aa7e](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/f40aa7e1d7dff889254c0e5a31f6475176ee2579) |
| Apple Watch Ultra 2 pixel density | ❌ 338 PPI | ✅ 326 PPI, matching Apple’s specifications | [Apple specs](https://support.apple.com/en-us/111832) | [f40aa7e](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/f40aa7e1d7dff889254c0e5a31f6475176ee2579) |
| Free space after a 32 MiB write | ❌ Repeated the earlier reading | ✅ Matched a fresh filesystem reading | [DeviceKit #525](https://github.com/devicekit/DeviceKit/issues/525) · Open | [da19bc5](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/da19bc572688a52707ece3a91d3f0359dc96c8dd) |
| Sorting charging and unplugged batteries at 50% | ❌ Unequal states with neither sorting first | ✅ Unplugged sorts before charging | [DeviceKit #527](https://github.com/devicekit/DeviceKit/issues/527) · Open | [be91a77](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/be91a77cbcd525f9127fde544f72d5c137789a27) |
| Mac battery in Catalyst | ❌ 0% | ✅ 80%, matching `pmset` | [Measured values](Docs/DeviceKitComparison.md#four-fixes-verified-in-swiftdevicekit) | [b05519e](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/b05519e62926f17b6019ab7019bf2ad4e67db054) |
| Unavailable display brightness in Catalyst | ❌ −100% | ✅ `nil` when UIKit has no reading | [Measurements](Docs/DeviceKitComparison.md#four-fixes-verified-in-swiftdevicekit) | [38f0148](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/38f014898b72aa3e6e55cec6c445f751989af41d) |
| Unknown battery in an iPad app on the Vision simulator | ❌ Full, 100% | ✅ `nil` for state and level | [Measurements](Docs/DeviceKitComparison.md#four-fixes-verified-in-swiftdevicekit) | [17f99f1](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/17f99f17fd78b2730ecae0c1afcce3ef711c8a5c) |
| Unknown ID with the display name “iPhone Xs” | ❌ Compares equal to the known XS | ✅ Remains a distinct device | [DeviceKit #526](https://github.com/devicekit/DeviceKit/issues/526) · Open | [5f5a6a0](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/5f5a6a01fd8103b05a78d55260426e772a443dbc) |
| Twice-wrapped iPhone XS simulator | ❌ `isPhone` is false | ✅ `isPhone` is true for the underlying XS | [DeviceKit #528](https://github.com/devicekit/DeviceKit/issues/528) · Open | [a6d14b5](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/a6d14b5724a81a9a5f19ce1642ecfdd16f5e1f90) |

We also track findings in SwiftDeviceKit’s own issue tracker. [Closed SwiftDeviceKit reports and fix commits](Docs/DeviceKitComparison.md#closed-swiftdevicekit-reports) · [Four audit fixes and their retest results](Docs/DeviceKitComparison.md#four-fixes-verified-in-swiftdevicekit).

## Installation

In Xcode, choose **File → Add Package Dependencies…** and paste this URL.

```text
https://github.com/Anywhere-Music-Player/SwiftDeviceKit.git
```

Select the **Exact Version** dependency rule and enter `2026.2.0`. Add one [product](#features) to your app target. [Release notes](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/releases/tag/2026.2.0)

## Requirements

Both products require Swift tools 6.4+ and use Swift 6 language mode. Core provides the same 173-model catalog on every platform. System readings depend on the operating system and hardware.

| Device | Minimum OS | Examples of System readings |
| --- | --- | --- |
| iPhone | iOS 18 | Battery, brightness, orientation and Display Zoom |
| iPad | iPadOS 18 | The same readings as iPhone, including in iPhone-only apps |
| Apple Watch | watchOS 11 | Battery, thermal state, storage and display pixels |
| Apple TV | tvOS 18 | Connected display pixels, thermal state and free storage |
| Mac | macOS 15 | Host OS, main display pixels and internal battery when present |
| Apple Vision Pro | visionOS 2 | Battery when available, thermal state, storage and Guided Access |

The [platform guide](Docs/PlatformSupport.md) lists model coverage, API availability, Release client sizes and test results for each platform.

## Features

| Feature | Core | System |
| :--- | :---: | :---: |
| [Model name, device family, processor and simulator detection](#get-the-current-device) | ✓ | ✓ |
| SwiftUI preview detection in debug builds | ✓ | ✓ |
| [Screen size, pixel density and both iPhone Duo panels](#show-display-sizes-on-iphone-and-iphone-duo) | ✓ | ✓ |
| [Camera lenses and variable aperture](#check-camera-hardware), LiDAR, Dynamic Island and Action button | ✓ | ✓ |
| [Face ID, Touch ID and Optic ID hardware](#identify-the-biometric-sensor) | ✓ | ✓ |
| [Apple Watch screen resolution and Vision Pro display specifications](#read-apple-watch-and-vision-pro-display-specifications) | ✓ | ✓ |
| [Apple Pencil and wireless charging support](#check-accessory-support-on-iphone-and-ipad), USB-C | ✓ | ✓ |
| 5G, eSIM and dual eSIM capabilities | ✓ | ✓ |
| [OS name and version](#include-the-model-and-os-in-a-support-report), `isPhone` and `isPad` with iOS idiom fallback | — | ✓ |
| [Battery percentage and charging state](#display-battery-percentage-and-charging-status) on battery-equipped devices | — | ✓ |
| [Low Power Mode and thermal state](#defer-background-work-when-power-or-cooling-is-limited) | — | ✓ |
| [Available and total storage capacity](#check-space-before-a-download) | — | ✓ |
| [Current display pixels, brightness and Display Zoom](#read-the-current-display-settings), orientation and Guided Access where available | — | ✓ |

## Usage

### SwiftDeviceKitCore

#### Get the current device

```swift
import SwiftDeviceKitCore

let device = Device.current
print(device.realDevice)   // e.g. iPhone 18 Pro
print(device.cpu)          // A20 Pro on iPhone 18 Pro
print(device.isSimulator)  // true in Simulator
```

#### Show display sizes on iPhone and iPhone Duo

Use `realDevice` to match the same model on hardware and in Simulator.

```swift
import SwiftDeviceKitCore

let model = Device.current.realDevice
if model == .iPhoneDuo {
    for screen in model.screens {
        print("\(screen.role) display · \(screen.diagonal)″")
    }
} else if let screen = model.screen(.main) {
    print("\(model) · \(screen.diagonal)″ display")
}
```

On iPhone 18 Pro this prints `iPhone 18 Pro · 6.3″ display`. On iPhone Duo it prints `outer display · 5.4″` and `inner display · 7.6″`. For the current window size, use your view’s geometry.

#### Identify the biometric sensor

```swift
import SwiftDeviceKitCore

let model = Device.current
if model.isFaceIDCapable {
    print("Face ID")
} else if model.isTouchIDCapable {
    print("Touch ID")
} else if model.isOpticIDCapable {
    print("Optic ID")
}
```

#### Check camera hardware

```swift
import SwiftDeviceKitCore

let device = Device.current
print(device.hasTelephotoCamera)  // true on iPhone 18 Pro, false on iPhone Duo
print(device.hasVariableAperture) // true on iPhone 18 Pro
```

#### Read Apple Watch and Vision Pro display specifications

```swift
import SwiftDeviceKitCore

let device = Device.current
if device.isWatch, let pixels = device.screen(.main)?.resolution {
    print("\(pixels.width) × \(pixels.height)")  // 416 × 496 on Apple Watch Series 12 (46 mm)
} else if let display = device.spatialDisplay {
    print(display.refreshRatesHz)  // [90, 96, 100, 120] on Apple Vision Pro (M5)
}
```

### SwiftDeviceKitSystem

Import System alone to use these examples. Access UIKit and WatchKit readings on the main actor.

#### Check accessory support on iPhone and iPad

```swift
import SwiftDeviceKitSystem

let device = Device.current
if device.isPhone && device.supportsWirelessCharging {
    print("This iPhone supports wireless charging.")
}
if device.isPad && device.applePencilSupport.contains(.pro) {
    print("This iPad supports Apple Pencil Pro.")
}
```

#### Include the model and OS in a support report

```swift
import SwiftDeviceKitSystem

let device = Device.current
if let name = device.systemName, let version = device.systemVersion {
    print("\(device.realDevice) · \(name) \(version)")
}
```

#### Display battery percentage and charging status

Available on iPhone, iPad, Apple Watch, Mac and Vision Pro. An unavailable battery reading returns `nil`, including on a desktop Mac without an internal battery. Designed for iPad/iPhone apps on Mac report battery readings as unavailable. Mac Catalyst reads the internal battery through IOKit. iPhone, iPad and Watch simulators retain the full-battery fallback for an unknown state.

```swift
import SwiftDeviceKitSystem

#if !os(tvOS)
@MainActor
func batteryLabel() -> String {
    switch Device.current.batteryState {
    case .charging(let percent): "\(percent)% · Charging"
    #if os(macOS) || targetEnvironment(macCatalyst)
    case .pluggedInNotCharging(let percent): "\(percent)% · Connected to power"
    #endif
    case .unplugged(let percent): "\(percent)%"
    case .full: "Charged"
    case nil: "Battery unavailable"
    }
}
#endif
```

Use `Device.current.batteryLevel` for the measured percentage. On Mac, IOKit can report a plugged-in battery as charged at 95–99%.

#### Defer background work when power or cooling is limited

```swift
import SwiftDeviceKitSystem

@MainActor
func shouldDeferBackgroundWork() -> Bool {
    let device = Device.current
    if device.isLowPowerModeEnabled == true { return true }
    switch device.thermalState {
    case .serious, .critical: return true
    default: return false
    }
}
```

#### Check space before a download

```swift
import SwiftDeviceKitSystem

func hasSpaceForDownload(bytes: Int64) -> Bool? {
    Device.volumeAvailableCapacity.map { Int64($0) >= bytes }
}
```

On watchOS both capacity properties return `Int64?`, including on arm64_32 watches. On the other platforms their return type is `Int?`. For a user-requested download on iPhone, iPad, Mac or Vision Pro, `volumeAvailableCapacityForImportantUsage` also accounts for space the OS can reclaim.

#### Read the current display settings

```swift
import SwiftDeviceKitSystem

#if !os(visionOS)
let device = Device.current
if let pixels = device.currentDisplayPixels {
    print("\(pixels.width) × \(pixels.height)")  // Connected display on Apple TV
}
#if os(iOS)
if let brightness = device.screenBrightness {
    print("Brightness: \(brightness)%")
}
if device.isZoomed == true {
    print("Display Zoom is enabled.")
}
#endif
#endif
```

To read physical orientation on iPhone or iPad, call `Device.beginOrientationUpdates()`,
read `Device.current.orientation` after a device orientation notification, and call
`Device.endOrientationUpdates()` when finished. [Orientation lifecycle](Docs/Screens.md#physical-orientation-on-ios-and-ipados)

## Documentation

- [Platform support and verification](Docs/PlatformSupport.md)
- [Migrating from DeviceKit](Docs/Migration.md)
- [Screen specifications](Docs/Screens.md)
- [Adding a model](Docs/Catalog.md) and [testing the catalog](Docs/Testing.md)
- [Changelog](CHANGELOG.md)

SwiftDeviceKit is distributed under the [MIT license](LICENSE). See [attribution](ATTRIBUTION.md) for the original authors and sources.
