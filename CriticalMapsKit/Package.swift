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
    .package(url: "https://github.com/pointfreeco/composable-core-location.git", from: "0.1.0"),
    .package(
      name: "SnapshotTesting",
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      .exact("1.8.2")
    )
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
        "FileClient",
        "GuideFeature",
        "Logger",
        "L10n",
        "InfoBar",
        "IDProvider",
        "MapFeature",
        "NextRideFeature",
        "SettingsFeature",
        "Styleguide",
        "UserDefaultsClient",
        "UIApplicationClient",
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
      name: "FileClient",
      dependencies: [
        "Helpers",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "GuideFeature",
      dependencies: [
        "Helpers",
        "L10n",
        "Logger",
        "Styleguide"
      ]
    ),
    .target(
      name: "Helpers",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
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
        "L10n",
        "Logger",
        "NextRideFeature",
        "Styleguide",
        .product(name: "ComposableCoreLocation", package: "composable-core-location"),
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
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
      name: "PathMonitorClient"
    ),
    .target(
      name: "SettingsFeature",
      dependencies: [
        "FileClient",
        "L10n",
        "Logger",
        "Helpers",
        "SharedModels",
        "Styleguide",
        "UIApplicationClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [.process("Resources/")]
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
      name: "TestHelper",
      dependencies: [
        .product(name: "SnapshotTesting", package: "SnapshotTesting")
      ]
    ),
    .target(
      name: "UIApplicationClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
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
        "TestHelper",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ],
      exclude: [
        "__Snapshots__"
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
        "TestHelper",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ],
      exclude: [
        "__Snapshots__"
      ]
    ),
    .testTarget(
      name: "MapFeatureTests",
      dependencies: [
        "MapFeature",
        "TestHelper",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ],
      exclude: [
        "__Snapshots__"
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
    ),
    .testTarget(
      name: "SettingsFeatureTests",
      dependencies: [
        "Helpers",
        "UserDefaultsClient",
        "SettingsFeature",
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        )
      ]
    )
  ]
)
