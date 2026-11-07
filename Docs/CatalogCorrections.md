# Catalog corrections — 7 November 2026

These changes intentionally differ from the frozen DeviceKit 5.9.0 and
pre-migration fixtures. The fixtures remain unchanged; tests allow only the
listed corrections.

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
