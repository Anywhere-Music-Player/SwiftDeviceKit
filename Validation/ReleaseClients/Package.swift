// swift-tools-version: 6.4
import PackageDescription
let package = Package(
  name: "ReleaseClients", platforms: [.iOS(.v18), .macOS(.v15), .watchOS(.v11), .tvOS(.v18), .visionOS(.v2)],
  dependencies: [.package(path: "../..")],
  targets: [
    .executableTarget(name: "CoreClient", dependencies: [.product(name: "SwiftDeviceKitCore", package: "SwiftDeviceKit")]),
    .executableTarget(name: "SystemClient", dependencies: [.product(name: "SwiftDeviceKitSystem", package: "SwiftDeviceKit")])
  ])
