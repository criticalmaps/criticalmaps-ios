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
    .library(name: "MapFeature", targets: ["MapFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"])
  ],
  dependencies: [
    .package(
      name: "swift-composable-architecture",
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .exact("0.18.0")
    ),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
    .package(url: "https://github.com/pointfreeco/composable-core-location.git", from: "0.1.0")
  ],
  targets: [
    .target(
      name: "ApiClient",
      dependencies: [
        "Helpers",
        "SharedModels"
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        "CriticalMapsKit",
        "Logger",
        "IDProvider",
        "MapFeature",
        "Styleguide",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "CriticalMapsKit",
      dependencies: [
        "ApiClient",
        "Helpers",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "Helpers",
      dependencies: []
    ),
    .target(
      name: "IDProvider",
      dependencies: ["Helpers"]
    ),
    .target(
      name: "Logger",
      dependencies: [
        .product(name: "Logging", package: "swift-log")
      ]
    ),
    .target(
      name: "MapFeature",
      dependencies: [
        "CriticalMapsKit",
        "Logger",
        "NextRideFeature",
        "Styleguide",
        .product(name: "ComposableCoreLocation", package: "composable-core-location"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: [
        "AppFeature",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
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
    .testTarget(
      name: "IDProviderTests",
      dependencies: ["IDProvider"]
    ),
    .testTarget(
      name: "MapFeatureTests",
      dependencies: [
        "MapFeature",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
    )
  ]
)
