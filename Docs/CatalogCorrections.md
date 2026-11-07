# Catalog corrections — 7 November 2026

These changes intentionally differ from the frozen DeviceKit 5.9.0 and
pre-migration fixtures. The fixtures remain unchanged; tests allow only the
listed corrections and separately cover the new model.

## Portrait reference orientation

Every catalog screen uses portrait width:height (short edge first), independently
of current window orientation. Normalize these nine inherited landscape records:

| Models | Previous ratio | Corrected ratio |
| --- | --- | --- |
| iPad Air 11-inch M3/M4 | 59:41 | 41:59 |
| iPad Air 13-inch M2/M3/M4 | 683:512 | 512:683 |
| iPad Pro 11-inch M4/M5 | 605:417 | 417:605 |
| iPad Pro 13-inch M4/M5 | 4:3 | 3:4 |

This changes the reference orientation, not the physical aspect ratio. The
scalar `screenRatio` and each `Screen.screenRatio` use the same convention.

## iPad Pro M5 Pencil support

Both sizes support Pencil Pro and Pencil USB-C, not Pencil 2nd generation.
The frozen migration snapshot includes the latter incorrectly. See Apple's
[compatibility list](https://support.apple.com/en-ge/108937),
[11-inch specifications](https://support.apple.com/en-gb/125406) and
[13-inch specifications](https://support.apple.com/en-gb/125407).

## iPad mini A20 Pro

The new case is `iPadMiniA20Pro`, with hardware identifiers `iPad19,1` and
`iPad19,2`. These were checked against Apple's installed CoreSimulator profile
in Xcode 27.2 (27B52):

```text
/Library/Developer/CoreSimulator/Profiles/DeviceTypes/
  iPad mini (A20 Pro).simdevicetype/Contents/Resources/profile.plist
representedModelIdentifiers = [iPad19,1, iPad19,2]
modelIdentifier = iPad19,2
```

Apple's [technical specifications](https://www.apple.com/ipad-mini/specs/), read
on 7 November 2026, establish the A20 Pro chip, 8.5-inch OLED panel, 326 PPI,
1512 × 2316 portrait pixels (126:193), rear wide camera, Touch ID, rounded
corners, USB-C, Pencil Pro and USB-C Pencil. Cellular variants support 5G and
eSIM. As with other iPads, the catalog case groups Wi-Fi and cellular variants;
these capabilities do not promise a cellular modem in each unit. Physical
hardware and Pencil pairing were not tested.

The comparison with DeviceKit reports this model as a deliberate addition;
DeviceKit 5.9.0 has no matching model. Hardware specifications are independently
asserted in the package's regression tests.
