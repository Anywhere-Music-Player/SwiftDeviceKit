// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

/// A known hardware model, a simulator wrapper, or an unrecognized identifier.
public enum Device: Sendable {
  /// Device is an [iPhone Xs](https://support.apple.com/kb/SP779)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP779/SP779-iphone-xs.jpg)
  case iPhoneXS
  /// Device is an [iPhone Xs Max](https://support.apple.com/kb/SP780)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP780/SP780-iPhone-Xs-Max.jpg)
  case iPhoneXSMax
  /// Device is an [iPhone Xʀ](https://support.apple.com/kb/SP781)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP781/SP781-iPhone-xr.jpg)
  case iPhoneXR
  /// Device is an [iPhone 11](https://support.apple.com/kb/SP804)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP804/sp804-iphone11_2x.png)
  case iPhone11
  /// Device is an [iPhone 11 Pro](https://support.apple.com/kb/SP805)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP805/sp805-iphone11pro_2x.png)
  case iPhone11Pro
  /// Device is an [iPhone 11 Pro Max](https://support.apple.com/kb/SP806)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP806/sp806-iphone11pro-max_2x.png)
  case iPhone11ProMax
  /// Device is an [iPhone SE (2nd generation)](https://support.apple.com/kb/SP820)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP820/iphone-se-2nd-gen_2x.png)
  case iPhoneSE2
  /// Device is an [iPhone 12](https://support.apple.com/kb/SP830)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP830/sp830-iphone12-ios14_2x.png)
  case iPhone12
  /// Device is an [iPhone 12 mini](https://support.apple.com/kb/SP829)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP829/sp829-iphone12mini-ios14_2x.png)
  case iPhone12Mini
  /// Device is an [iPhone 12 Pro](https://support.apple.com/kb/SP831)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP831/iphone12pro-ios14_2x.png)
  case iPhone12Pro
  /// Device is an [iPhone 12 Pro Max](https://support.apple.com/kb/SP832)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP832/iphone12promax-ios14_2x.png)
  case iPhone12ProMax
  /// Device is an [iPhone 13](https://support.apple.com/kb/SP851)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1092/en_US/iphone-13-240.png)
  case iPhone13
  /// Device is an [iPhone 13 mini](https://support.apple.com/kb/SP847)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1091/en_US/iphone-13mini-240.png)
  case iPhone13Mini
  /// Device is an [iPhone 13 Pro](https://support.apple.com/kb/SP852)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1093/en_US/iphone-13pro-240.png)
  case iPhone13Pro
  /// Device is an [iPhone 13 Pro Max](https://support.apple.com/kb/SP848)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1095/en_US/iphone-13promax-240.png)
  case iPhone13ProMax
  /// Device is an [iPhone SE (3rd generation)](https://support.apple.com/kb/SP867)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1136/en_US/iphone-se-3rd-gen-colors-240.png)
  case iPhoneSE3
  /// Device is an [iPhone 14](https://support.apple.com/kb/SP873)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
  case iPhone14
  /// Device is an [iPhone 14 Plus](https://support.apple.com/kb/SP874)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
  case iPhone14Plus
  /// Device is an [iPhone 14 Pro](https://support.apple.com/kb/SP875)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
  case iPhone14Pro
  /// Device is an [iPhone 14 Pro Max](https://support.apple.com/kb/SP876)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
  case iPhone14ProMax
  /// Device is an [iPhone 15](https://support.apple.com/kb/SP901)
  case iPhone15
  /// Device is an [iPhone 15 Plus](https://support.apple.com/kb/SP902)
  case iPhone15Plus
  /// Device is an [iPhone 15 Pro](https://support.apple.com/kb/SP903)
  case iPhone15Pro
  /// Device is an [iPhone 15 Pro Max](https://support.apple.com/kb/SP904)
  case iPhone15ProMax
  /// Device is an [iPhone 16](https://support.apple.com/121029)
  case iPhone16
  /// Device is an [iPhone 16 Plus](https://support.apple.com/121030)
  case iPhone16Plus
  /// Device is an [iPhone 16 Pro](https://support.apple.com/121031)
  case iPhone16Pro
  /// Device is an [iPhone 16 Pro Max](https://support.apple.com/121032)
  case iPhone16ProMax
  /// Device is an [iPhone 16e](https://support.apple.com/122208)
  ///
  /// ![Image](https://cdsassets.apple.com/live/7WUAS350/images/tech-specs/122208-iphone-16e.png)
  case iPhone16e
  /// Device is an [iPhone 17](https://support.apple.com/125089)
  case iPhone17
  /// Device is an [iPhone 17 Pro](https://support.apple.com/125090)
  case iPhone17Pro
  /// Device is an [iPhone 17 Pro Max](https://support.apple.com/125091)
  case iPhone17ProMax
  /// Device is an [iPhone Air](https://support.apple.com/125092)
  case iPhoneAir
  /// Device is an [iPhone 17e](https://support.apple.com/126470)
  case iPhone17e
  /// Device is an [iPhone 18 Pro](https://support.apple.com/en-us/148590)
  case iPhone18Pro
  /// Device is an [iPhone 18 Pro Max](https://support.apple.com/en-us/148591)
  case iPhone18ProMax
  /// iPhone Duo. Use screens for both panels; scalar display metrics describe the outer panel.
  case iPhoneDuo
  /// Device is an [iPad Air (3rd generation)](https://support.apple.com/kb/SP787)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP787/ipad-air-2019.jpg)
  case iPadAir3
  /// Device is an [iPad (7th generation)](https://support.apple.com/kb/SP807)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP807/sp807-ipad-7th-gen_2x.png)
  case iPad7
  /// Device is an [iPad (8th generation)](https://support.apple.com/kb/SP822)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP822/sp822-ipad-8gen_2x.png)
  case iPad8
  /// Device is an [iPad (9th generation)](https://support.apple.com/kb/SP849)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1096/en_US/ipad-9gen-240.png)
  case iPad9
  /// Device is an [iPad (10th generation)](https://support.apple.com/kb/SP884)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP884/sp884-ipad-10gen-960_2x.png)
  case iPad10
  /// Device is an [iPad (A16)](https://support.apple.com/122240)
  case iPadA16
  /// Device is an [iPad Air (4th generation)](https://support.apple.com/kb/SP828)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP828/sp828ipad-air-ipados14-960_2x.png)
  case iPadAir4
  /// Device is an [iPad Air (5th generation)](https://support.apple.com/kb/SP866)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP866/sp866-ipad-air-5gen_2x.png)
  case iPadAir5
  /// Device is an [iPad Air 11-inch (M2)](https://support.apple.com/119894)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301027&size=240x240)
  case iPadAir11M2
  /// Device is an [iPad Air 13-inch (M2)](https://support.apple.com/119893)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301029&size=240x240)
  case iPadAir13M2
  /// Device is an [iPad Air 11-inch (M3)](https://support.apple.com/122241)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301027&size=240x240)
  case iPadAir11M3
  /// Device is an [iPad Air 13-inch (M3)](https://support.apple.com/122242)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301029&size=240x240)
  case iPadAir13M3
  /// Device is an [iPad Air 11-inch (M4)](https://support.apple.com/126471)
  case iPadAir11M4
  /// Device is an [iPad Air 13-inch (M4)](https://support.apple.com/126472)
  case iPadAir13M4
  /// Device is an [iPad mini (5th generation)](https://support.apple.com/kb/SP788)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP788/ipad-mini-2019.jpg)
  case iPadMini5
  /// Device is an [iPad mini (6th generation)](https://support.apple.com/kb/SP850)
  ///
  /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1097/en_US/ipad-mini-6gen-240.png)
  case iPadMini6
  /// Device is an [iPad mini (A17 Pro)](https://support.apple.com/en-us/121456)
  ///
  /// ![Image](https://cdsassets.apple.com/live/7WUAS350/images/tech-specs/iPad_mini_A17_Pro_Wi-Fi_Lineup_Print__USEN.png)
  case iPadMiniA17Pro
  /// Device is an [iPad mini (A20 Pro)](https://www.apple.com/ipad-mini/specs/).
  case iPadMiniA20Pro
  /// Device is an [iPad Pro 11-inch](https://support.apple.com/kb/SP784)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP784/ipad-pro-11-2018_2x.png)
  case iPadPro11Inch
  /// Device is an [iPad Pro 12.9-inch (3rd generation)](https://support.apple.com/kb/SP785)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP785/ipad-pro-12-2018_2x.png)
  case iPadPro12Inch3
  /// Device is an [iPad Pro 11-inch (2nd generation)](https://support.apple.com/kb/SP814)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP814/ipad-pro-11-2020.jpeg)
  case iPadPro11Inch2
  /// Device is an [iPad Pro 12.9-inch (4th generation)](https://support.apple.com/kb/SP815)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP815/ipad-pro-12-2020.jpeg)
  case iPadPro12Inch4
  /// Device is an [iPad Pro 11-inch (3rd generation)](https://support.apple.com/kb/SP843)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP843/ipad-pro-11_2x.png)
  case iPadPro11Inch3
  /// Device is an [iPad Pro 12.9-inch (5th generation)](https://support.apple.com/kb/SP844)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP844/ipad-pro-12-9_2x.png)
  case iPadPro12Inch5
  /// Device is an [iPad Pro 11-inch (4th generation)](https://support.apple.com/kb/SP882)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP882/ipad-pro-4gen-mainimage_2x.png)
  case iPadPro11Inch4
  /// Device is an [iPad Pro 12.9-inch (6th generation)](https://support.apple.com/kb/SP883)
  ///
  /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP882/ipad-pro-4gen-mainimage_2x.png)
  case iPadPro12Inch6
  /// Device is an [iPad Pro 11-inch (M4)](https://support.apple.com/en-us/119892)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301031&size=240x240)
  case iPadPro11M4
  /// Device is an [iPad Pro 13-inch (M4)](https://support.apple.com/en-us/119891)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301033&size=240x240)
  case iPadPro13M4
  /// Device is an [iPad Pro 11-inch (M5)](https://support.apple.com/en-us/125406)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301271&size=240x240)
  case iPadPro11M5
  /// Device is an [iPad Pro 13-inch (M5)](https://support.apple.com/en-us/125406)
  ///
  /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301273&size=240x240)
  case iPadPro13M5

  /// Device is [Simulator](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html)
  ///
  /// ![Image](https://developer.apple.com/assets/elements/icons/256x256/xcode-6.png)
  indirect case simulator(Device)

  /// Device is not yet known (implemented)
  /// You can still use this enum as before but the description equals the identifier (you can get multiple identifiers for the same product class
  /// (e.g. "iPhone6,1" or "iPhone 6,2" do both mean "iPhone 5s"))
  case unknown(String)

}

// Identity includes the enum case and associated values, independently of display names.
extension Device: Equatable {}
