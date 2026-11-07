# Attribution

SwiftDeviceKit is derived from [DeviceKit 5.9.0](https://github.com/devicekit/DeviceKit/releases/tag/5.9.0),
released on 22 September 2026, at commit
`19528aa07e1426626ea9fb2c4a161edf43c4f9e8`.
The original MIT license is retained in [LICENSE](LICENSE), together with the
copyright notices in the derived source files.

The iPhone Duo identifier and foldability were adapted from Zandor Smith's
[DeviceKit pull request #507](https://github.com/devicekit/DeviceKit/pull/507),
at commit `1b48a59b0fe0c93ccf2db5392957bc5615ae5068`.
Apple's locally installed `iPhone Duo.simdevicetype` profile, version 405,
independently identifies the model as `iPhone19,4`.

Duo capabilities and both display records use
[Apple's technical specifications](https://www.apple.com/iphone-duo/specs/),
verified on 21 October 2026. This source supersedes the imported pull request's
unconfirmed capability defaults. An optical-quality camera crop is not counted
as a separate telephoto camera.

The installed simulator profile lists the inner panel as 2007 × 2853 pixels at
460 PPI, which differs from Apple's hardware specification. Display metadata uses
the published hardware values; the simulator profile is evidence for identity only.

Apple Watch and Apple TV case names and compatibility behavior follow
[DeviceKit 5.10.0](https://github.com/devicekit/DeviceKit/tree/fab82bd988405367c915143e293479f481e93ba0).
The differential tests execute that exact version. Apple's model lists, firmware
identifiers, technical specifications and simulator profiles supply independent
hardware checks. See [platform support](Docs/PlatformSupport.md).
