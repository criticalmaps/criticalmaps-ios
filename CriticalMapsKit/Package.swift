// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "CriticalMapsKit",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "CriticalMapsKit", targets: ["CriticalMapsKit"]),
    .library(name: "MapFeature", targets: ["MapFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "InfoBar", targets: ["InfoBar"])
  ],
  dependencies: [
    .package(
      name: "swift-composable-architecture",
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "0.18.0")
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
        "L10n",
        "InfoBar",
        "IDProvider",
        "MapFeature",
        "NextRideFeature",
        "Styleguide",
        "UserDefaultsClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [.process("Resources")]
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
      name: "InfoBar",
      dependencies: [
        "Styleguide",
        "Helpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "L10n",
      dependencies: [],
      resources: [.process("Resources")]
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
        "InfoBar",
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
        "CriticalMapsKit",
        "L10n",
        "Logger",
        "SharedModels",
        "Styleguide",
        "UserDefaultsClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "PathMonitorClient",
      dependencies: []
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        "Helpers"
      ]
    ),
    .target(
      name: "Styleguide",
      dependencies: [],
      resources: [.process("Resources")]
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
        "Helpers",
        "UserDefaultsClient"
      ]),
    .testTarget(
      name: "IDProviderTests",
      dependencies: ["IDProvider"]
    ),
    .testTarget(
      name: "InfoBarTests",
      dependencies: [
        "InfoBar",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
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
    ),
    .testTarget(
      name: "NextRideFeatureTests",
      dependencies: [
        "Helpers",
        "UserDefaultsClient",
        "NextRideFeature",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
    )
  ]
)
