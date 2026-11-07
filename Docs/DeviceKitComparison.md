07 Nov 20:29 · 2026 · Europe/Kyiv

# SwiftDeviceKit vs DeviceKit 5.10.0

SwiftDeviceKit identified the Mac hosting an iPad app, matched Apple's Watch SE 3 case sizes and M5 iPad Pro Pencil specifications, and returned fresh disk-space readings. The comparison also exposed four bugs in SwiftDeviceKit. All four fixes passed a repeat of the original scenarios.

## Four fixes verified in SwiftDeviceKit

Three of these bugs also reproduced in DeviceKit 5.10.0. The group migration affected SwiftDeviceKit.

| Scenario | SwiftDeviceKit before | SwiftDeviceKit after | Verification |
| --- | --- | --- | --- |
| Battery on Mac in Catalyst / Designed for iPad | 0% / 100% | **80% / `nil`** | On the same physical Mac, `pmset` reported 80% before and after both runs. Catalyst read the battery through IOKit. The iPad build reported the host reading as unavailable. DeviceKit repeated 0% / 100%. · [b05519e](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/b05519e62926f17b6019ab7019bf2ad4e67db054) |
| Migrating `allXSeriesDevices` | The suggested replacement expanded 35 iPhones to 71 devices. | **35 iPhones in the original order** | The compiler now suggests `allPhonesWithSensorHousing`. Every member and its position matched the deprecated group. · [c03ba5d](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/c03ba5da7f4fa88748721b69d8c8d6141317ee33) |
| Unavailable brightness in Catalyst | −100% | **`nil`** | UIKit returned a negative reading. The iPhone simulator control still reported 50%, and the regression test preserved a real 0%. DeviceKit repeated −100% in Catalyst. · [38f0148](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/38f014898b72aa3e6e55cec6c445f751989af41d) |
| Unknown battery in an iPad app on the Vision simulator | Full, 100% | **`nil` state and level** | UIKit returned unknown and −1. Native visionOS also returned `nil`. DeviceKit repeated 100% in the iPad app. · [17f99f1](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/17f99f17fd78b2730ecae0c1afcce3ef711c8a5c) |

## Where did the answers differ?

| Input or operation | SwiftDeviceKit | DeviceKit 5.10.0 | Independent check |
| --- | --- | --- | --- |
| iPad app on a physical M1 Pro MacBook Pro | MacBook Pro (14-inch, M1 Pro) | iPad Pro (12.9-inch, 3rd generation) | `sysctl hw.model` returned `MacBookPro18,3`. |
| iPhone-only app on an iPad Pro M5 simulator | Only `isPad` was true | Both `isPhone` and `isPad` were true | CoreSimulator identified an iPad. UIKit supplied the phone interface idiom. |
| Watch SE 3, `Watch7,14` / `Watch7,15` | 44 mm / 40 mm | 40 mm / 44 mm | Apple's 44 mm and 40 mm CoreSimulator profiles list those IDs respectively. |
| Apple Watch Ultra 2, `Watch7,5` | 326 PPI | 338 PPI | Apple specifies 326 PPI and 410 × 502 pixels. [Apple Watch Ultra 2 specifications](https://support.apple.com/en-us/111832) |
| iPad Pro M5, 11-inch and 13-inch | Pencil Pro and USB-C | Also lists Pencil 2nd generation | Apple lists Pro and USB-C for both sizes. [Apple Pencil compatibility](https://support.apple.com/en-us/108937) |
| Free space after writing and syncing 32 MiB | 24,333,705,216 bytes | Repeated an earlier reading of 24,368,463,872 bytes | Fresh Foundation reads immediately before and after the getter both returned 24,333,705,216 bytes. |
| iPhone Duo, `iPhone19,4` | A20 Pro, 5.4″ outer panel, 460 PPI. Also exposes the 7.6″ inner panel. | Same chip and outer-panel values | Both libraries matched Apple's outer-panel specifications. Apple also lists 430 PPI for the inner panel. [iPhone Duo specifications](https://www.apple.com/iphone-duo/specs/) |
| 11-inch iPad Pro M5 screen ratio | 417:605 | 605:417 | Apple lists 1668 × 2420 pixels in portrait, which reduces to 417:605. [Apple specifications](https://support.apple.com/en-us/125406) |
| `unknown("iPhone Xs") == iPhoneXS` | False | True | Explicit construction gives two distinct enum cases with the same display name. [#3](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/3) |
| `realDevice` on a twice-wrapped iPhone XS | iPhone XS | Simulator wrapping iPhone XS | The input had two simulator layers around the known model. [#7](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/7) |

Most shared iPhone and iPad IDs agreed. On **87 of 105** IDs, all 32 compared fields matched for the unwrapped model. The other 18 IDs represent nine iPad models with differences in screen-ratio orientation or Pencil support. All nine compared fields matched for the four shared Apple TV IDs. On an iPhone simulator, SwiftDeviceKit reports the catalog model's camera lenses and DeviceKit returns an empty list. Neither result measures whether an app can capture video.

## Which devices did each library recognize?

A model can have several hardware identifiers. The iPhone XS Max, for example, has one catalog entry for two IDs. The table counts IDs that resolve to a named model in each library. The CSV gives both model cases for every input. [Browse the 324 identifiers](DeviceKitComparisonIdentifiers.csv).

| Family | SwiftDeviceKit IDs | DeviceKit IDs | Recognized by both |
| --- | ---: | ---: | ---: |
| iPhone | 39 | 64 | 39 |
| iPad | 68 | 104 | 66 |
| Apple Watch | 40 | 62 | 40 |
| Apple TV | 5 | 4 | 4 |
| Mac | 81 | 0 | 0 |
| Apple Vision Pro | 2 | 0 | 0 |
| iPod touch | 0 | 3 | 0 |
| HomePod | 0 | 1 | 0 |
| **Total** | **235** | **238** | **149** |

Of the 324 distinct IDs, **86 were recognized only by SwiftDeviceKit** and **89 only by DeviceKit**. The former include all 81 Mac IDs, both Vision IDs, both iPad mini (A20 Pro) IDs and the fourth-generation Apple TV 4K. The latter are older iPhone, iPad and Watch models, iPod touch and HomePod. DeviceKit's native visionOS placeholder returns the generic name “Apple Vision Pro” even for an unknown ID. It does not distinguish the M2 and M5 models.

## Test scope and reproduction

The first comparison used SwiftDeviceKit `4af5ee3`. The verified fixes are in `17f99f1`. Both runs used DeviceKit 5.10.0 (`fab82bd9`), Xcode 27.2 (27B52) and Swift 6.4.2. The post-fix catalog suite passed **14,518 comparisons** across iOS (13,300), watchOS (1,134) and tvOS (84). These count field and group comparisons, including expected differences. The full SwiftDeviceKit package tests also passed on the physical Mac (46 tests), iPhone simulator (87) and native Vision simulator (44).

The Mac was the only physical device in this run. Mobile, Watch, TV and Vision runtime observations came from simulators. Hardware identifiers and selected specifications were checked against Apple sources. Agreement alone does not validate every property, regional cellular configuration or physical accessory. [Platform coverage and sources](PlatformSupport.md)

- **Inspect a device in Xcode.** On the `dev/device-comparison-app` branch, open `Examples/DeviceComparison/DeviceComparison.xcodeproj`, select the `DeviceComparison` scheme and run it. The app shows both libraries' values and lets you enter a hardware ID. [Comparison app project](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/tree/c03655acb20e4267a66a661982b4c26548b2bd68/Examples/DeviceComparison)
- **Repeat the catalog checks.** The standalone XCTest package runs both libraries and exports the measured differences to Markdown and JSON. [Comparison runner and commands](../Validation/DeviceKitComparison/README.md)
