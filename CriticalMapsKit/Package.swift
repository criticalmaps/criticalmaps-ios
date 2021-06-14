// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "CriticalMapsKit",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13)
  ],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "CriticalMapsKit", targets: ["CriticalMapsKit"]),
    .library(name: "NextRideFeature", targets: ["NextRideFeature"])
  ],
  dependencies: [
    .package(
      name: "swift-composable-architecture",
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .exact("0.18.0")
    ),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0")
  ],
  targets: [
    .target(
      name: "ApiClient",
      dependencies: []
    ),
    .target(
      name: "CriticalMapsKit",
      dependencies: [
        "ApiClient",
        "Helpers",
        "NextRideFeature",
        "SharedModels",
        "Styleguide",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "Helpers",
      dependencies: []
    ),
    .target(
      name: "Logger",
      dependencies: [
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .target(
      name: "NextRideFeature",
      dependencies: [
        "Logger",
        "SharedModels",
        "UserDefaultsClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        "Helpers"
      ]
    ),
    .target(
      name: "Styleguide",
      dependencies: []
    ),
    .target(
      name: "UserDefaultsClient",
      dependencies: [
        "Helpers",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "CriticalMapsKitTests",
      dependencies: [
        "CriticalMapsKit",
        "NextRideFeature",
        "Helpers",
        "UserDefaultsClient"
      ]),
  ]
)
