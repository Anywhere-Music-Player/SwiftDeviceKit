// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "SwiftDeviceKit",
  platforms: [.iOS(.v18)],
  products: [
    .library(name: "SwiftDeviceKitCore", targets: ["SwiftDeviceKitCore"]),
    .library(name: "SwiftDeviceKitSystem", targets: ["SwiftDeviceKitSystem"]),
  ],
  targets: [
    .target(name: "SwiftDeviceKitCore"),
    .target(
      name: "SwiftDeviceKitSystem",
      dependencies: ["SwiftDeviceKitCore"],
      resources: [.process("PrivacyInfo.xcprivacy")]
    ),
    .testTarget(
      name: "SwiftDeviceKitCoreTests",
      dependencies: ["SwiftDeviceKitCore"],
      resources: [.process("Fixtures")]
    ),
    .testTarget(
      name: "SwiftDeviceKitSystemTests",
      dependencies: ["SwiftDeviceKitSystem"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
