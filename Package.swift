// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "SwiftDeviceKit",
  platforms: [.iOS(.v18)],
  products: [
    .library(name: "SwiftDeviceKit", targets: ["SwiftDeviceKit"])
  ],
  targets: [
    .target(
      name: "SwiftDeviceKit",
      resources: [.process("PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "SwiftDeviceKitTests",
      dependencies: ["SwiftDeviceKit"],
      resources: [.process("Fixtures")]
    ),
  ],
  swiftLanguageModes: [.v6]
)
