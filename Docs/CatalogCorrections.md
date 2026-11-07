# Catalog corrections — 7 November 2026

These changes intentionally differ from the frozen DeviceKit 5.9.0 and
pre-migration fixtures. The fixtures remain unchanged; tests allow only the
listed corrections.

## iPad Pro M5 Pencil support

Both sizes support Pencil Pro and Pencil USB-C, not Pencil 2nd generation.
The frozen migration snapshot includes the latter incorrectly. See Apple's
[compatibility list](https://support.apple.com/en-ge/108937),
[11-inch specifications](https://support.apple.com/en-gb/125406) and
[13-inch specifications](https://support.apple.com/en-gb/125407).
