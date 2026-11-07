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

## Closed SwiftDeviceKit reports

On 8 November 2026, the SwiftDeviceKit tracker contained ten closed bug reports and one completed model request ([iPad mini with A20 Pro](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/8)). Each fix below is included in 2026.2.0. The DeviceKit column links matching upstream reports that were open on that date. A dash means this index cites only the SwiftDeviceKit report for that scenario.

| SwiftDeviceKit report | Fix commit | DeviceKit report |
| --- | --- | --- |
| [#1 · Free-space readings after a synchronous write](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/1) | [`da19bc5`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/da19bc572688a52707ece3a91d3f0359dc96c8dd) | [#525 · Open](https://github.com/devicekit/DeviceKit/issues/525) |
| [#2 · Enlarged Display Zoom on a 3× screen](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/2) | [`4232956`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/42329567892d1de944156793e285b9524ca3865d) | — |
| [#3 · Unknown identifier equal to a model’s display name](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/3) | [`5f5a6a0`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/5f5a6a01fd8103b05a78d55260426e772a443dbc) | [#526 · Open](https://github.com/devicekit/DeviceKit/issues/526) |
| [#4 · Apple Pencil compatibility on iPad Pro M5](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/4) | [`a066b86`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/a066b86e1585043b910bd8eb5113cd1f8b130a32) | [#504 · Open](https://github.com/devicekit/DeviceKit/issues/504) |
| [#5 · Portrait screen ratios across nine iPad models](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/5) | [`887a59f`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/887a59f8f92b224c000758c88932693d37d5050b) | [#433 · Open](https://github.com/devicekit/DeviceKit/issues/433) (2024 iPads only) |
| [#6 · Ordering battery states at equal percentages](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/6) | [`be91a77`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/be91a77cbcd525f9127fde544f72d5c137789a27) | [#527 · Open](https://github.com/devicekit/DeviceKit/issues/527) |
| [#7 · Family and capabilities through nested simulator wrappers](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/7) | [`a6d14b5`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/a6d14b5724a81a9a5f19ce1642ecfdd16f5e1f90) | [#528 · Open](https://github.com/devicekit/DeviceKit/issues/528) |
| [#9 · iPad classified as both phone and tablet in an iPhone-only app](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/9) | [`8daaaa9`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/8daaaa97d29916d9446780e0059332138888e90c) | [#447 · Open](https://github.com/devicekit/DeviceKit/issues/447) |
| [#10 · Mac host reported as an iPad in an iOS app](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/10) | [`61a13c8`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/61a13c8a0a2d383eb11e0268d5cf11de099cf7ec) | [#506 · Open](https://github.com/devicekit/DeviceKit/issues/506) |
| [#11 · 13-inch iPad Pro M5 documentation linked to the 11-inch specifications](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/11) | [`239f7f9`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/239f7f96a99a67b8ca4831eef11fec7f6aa86ef6) | — |

The SwiftDeviceKit maintainers filed the four DeviceKit reports numbered 525 through 528 with reproducers and downstream fix links.

### Additional fixes recorded in commits

The following corrections in 2026.2.0 are documented in their commits and regression tests. The [four audit retests](#four-fixes-verified-in-swiftdevicekit) document Catalyst battery and brightness, Vision simulator battery readings and the X-series group migration separately.

| Scenario | Result and verification | SwiftDeviceKit fix |
| --- | --- | --- |
| 2024 Mac mini chip identification | The catalog maps Mac16,10 to M4 and Mac16,11 to M4 Pro. A macOS regression test checks both models and chips. | [`bc1b3bf`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/bc1b3bf6991252d018741e87283b5e58e4df5505) |
| Storage larger than 4 GiB on a 32-bit Watch | Total and free capacity preserve 64-bit byte counts. The regression fixture includes 4,294,967,297 bytes and builds for arm64_32. | [`830af2a`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/830af2ad69a225283e42ddfba68fbff6728553d0) |
| Mac battery marked charged at 97% | The measured percentage stays at 97%. Unit tests cover 95–100%. | [`3ad8029`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/3ad80295d4e62cc14c2709eab7d86d0ebe81e32b) |
| Mac on external power with charging paused | The battery keeps its measured level and reports plugged in with charging paused. Controlled tests cover pausing and resuming at 80%. | [`8fe32a9`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/8fe32a9ae1c257ed50cae62919bca6ae0aae7c21) |
| An iPad app hosted on Vision Pro | The app reports visionOS. A Vision simulator run reproduced the earlier iPadOS result and verified the correction. | [`d8f581a`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/d8f581a16321972b804e2bd0830a366c0c045d95) |
| Requesting physical orientation updates | Balanced begin/end calls control notifications. An iPhone simulator UI test rotated between portrait and landscape. | [`4af5ee3`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/4af5ee3d97aa7f83e64b5d9b2ba8b03dcca6bd08) |
| Simulator groups included native Macs | All five simulator groups retain only models with a simulator runtime. A macOS test checks membership and order. | [`bc9c6c8`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/bc9c6c8c2ecc881b6628c05fe374de844af61f53) |
| Unknown battery readings on physical iPhone, iPad and Watch | An unknown reading returns `nil` on hardware. Tests use controlled inputs for hardware and simulator behavior. | [`4d61a77`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/4d61a773f690461a34ad71cdf178994cc894604c) |
| Empty or absent simulator model identifier | The simulator wrapper retains the raw identifier. Tests cover both architecture aliases and the iPad compatibility case on Vision. | [`37437a1`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/37437a14e436ba52b933165adbda786bf1ea25b7) |
| Formatting a deeply nested simulator name | Iterative formatting preserves both public names. Tests cover wrappers up to 2,048 levels deep. | [`36916a3`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/36916a33d44508b4b0d2e815e9342c412f999e68) |
| Apple Watch Ultra 2 model name | Both model names use Apple’s spelling. The Watch simulator comparison checks the hardware model and simulator wrapper. | [`39b158d`](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/commit/39b158de8ddf3815ef8a54f23ac35a5ed9b84ac5) |

## Where did the answers differ?

| Input or operation | DeviceKit 5.10.0 | SwiftDeviceKit | Independent check |
| --- | --- | --- | --- |
| iPad app on a physical M1 Pro MacBook Pro | iPad Pro (12.9-inch, 3rd generation) | MacBook Pro (14-inch, M1 Pro) | `sysctl hw.model` returned `MacBookPro18,3`. |
| iPhone-only app on an iPad Pro M5 simulator | Both `isPhone` and `isPad` were true | Only `isPad` was true | CoreSimulator identified an iPad. UIKit supplied the phone interface idiom. |
| Watch SE 3, `Watch7,14` / `Watch7,15` | 40 mm / 44 mm | 44 mm / 40 mm | Apple's 44 mm and 40 mm CoreSimulator profiles list those IDs respectively. |
| Apple Watch Ultra 2, `Watch7,5` | 338 PPI | 326 PPI | Apple specifies 326 PPI and 410 × 502 pixels. [Apple Watch Ultra 2 specifications](https://support.apple.com/en-us/111832) |
| iPad Pro M5, 11-inch and 13-inch | Also lists Pencil 2nd generation | Pencil Pro and USB-C | Apple lists Pro and USB-C for both sizes. [Apple Pencil compatibility](https://support.apple.com/en-us/108937) |
| Free space after writing and syncing 32 MiB | Repeated an earlier reading of 24,368,463,872 bytes | 24,333,705,216 bytes | Fresh Foundation reads immediately before and after the getter both returned 24,333,705,216 bytes. |
| iPhone Duo, `iPhone19,4` | Same chip and outer-panel values | A20 Pro, 5.4″ outer panel, 460 PPI. Also exposes the 7.6″ inner panel. | Both libraries matched Apple's outer-panel specifications. Apple also lists 430 PPI for the inner panel. [iPhone Duo specifications](https://www.apple.com/iphone-duo/specs/) |
| 11-inch iPad Pro M5 screen ratio | 605:417 | 417:605 | Apple lists 1668 × 2420 pixels in portrait, which reduces to 417:605. [Apple specifications](https://support.apple.com/en-us/125406) |
| `unknown("iPhone Xs") == iPhoneXS` | True | False | Explicit construction gives two distinct enum cases with the same display name. [#3](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/3) |
| `realDevice` on a twice-wrapped iPhone XS | Simulator wrapping iPhone XS | iPhone XS | The input had two simulator layers around the known model. [#7](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/7) |

Most shared iPhone and iPad IDs agreed. On **87 of 105** IDs, all 32 compared fields matched for the unwrapped model. The other 18 IDs represent nine iPad models with differences in screen-ratio orientation or Pencil support. All nine compared fields matched for the four shared Apple TV IDs. On an iPhone simulator, SwiftDeviceKit reports the catalog model's camera lenses and DeviceKit returns an empty list. Neither result measures whether an app can capture video.

## Which devices did each library recognize?

A model can have several hardware identifiers. The iPhone XS Max, for example, has one catalog entry for two IDs. The table counts IDs that resolve to a named model in each library. The CSV gives both model cases for every input. [Browse the 324 identifiers](DeviceKitComparisonIdentifiers.csv).

| Family | DeviceKit IDs | SwiftDeviceKit IDs | Recognized by both |
| --- | ---: | ---: | ---: |
| iPhone | 64 | 39 | 39 |
| iPad | 104 | 68 | 66 |
| Apple Watch | 62 | 40 | 40 |
| Apple TV | 4 | 5 | 4 |
| Mac | 0 | 81 | 0 |
| Apple Vision Pro | 0 | 2 | 0 |
| iPod touch | 3 | 0 | 0 |
| HomePod | 1 | 0 | 0 |
| **Total** | **238** | **235** | **149** |

Of the 324 distinct IDs, **86 were recognized only by SwiftDeviceKit** and **89 only by DeviceKit**. The former include all 81 Mac IDs, both Vision IDs, both iPad mini (A20 Pro) IDs and the fourth-generation Apple TV 4K. The latter are older iPhone, iPad and Watch models, iPod touch and HomePod. DeviceKit's native visionOS placeholder returns the generic name “Apple Vision Pro” even for an unknown ID. It does not distinguish the M2 and M5 models.

## Test scope and reproduction

The first comparison used SwiftDeviceKit `4af5ee3`. The verified fixes are in `17f99f1`. Both runs used DeviceKit 5.10.0 (`fab82bd9`), Xcode 27.2 (27B52) and Swift 6.4.2. The post-fix catalog suite passed **14,518 comparisons** across iOS (13,300), watchOS (1,134) and tvOS (84). These count field and group comparisons, including expected differences. The full SwiftDeviceKit package tests also passed on the physical Mac (46 tests), iPhone simulator (87) and native Vision simulator (44).

The Mac was the only physical device in this run. Mobile, Watch, TV and Vision runtime observations came from simulators. Hardware identifiers and selected specifications were checked against Apple sources. Agreement alone does not validate every property, regional cellular configuration or physical accessory. [Platform coverage and sources](PlatformSupport.md)

- **Inspect a device in Xcode.** On the `dev/device-comparison-app` branch, open `Examples/DeviceComparison/DeviceComparison.xcodeproj`, select the `DeviceComparison` scheme and run it. The app shows both libraries' values and lets you enter a hardware ID. [Comparison app project](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/tree/c03655acb20e4267a66a661982b4c26548b2bd68/Examples/DeviceComparison)
- **Repeat the catalog checks.** The standalone XCTest package runs both libraries and exports the measured differences to Markdown and JSON. [Comparison runner and commands](../Validation/DeviceKitComparison/README.md)
