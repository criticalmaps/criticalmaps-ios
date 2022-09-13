// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "CriticalMapsKit",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(name: "ApiClient", targets: ["ApiClient"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "ChatFeature", targets: ["ChatFeature"]),
    .library(name: "GuideFeature", targets: ["GuideFeature"]),
    .library(name: "MapFeature", targets: ["MapFeature"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "TwitterFeature", targets: ["SocialFeature"])
  ],
  dependencies: [
    .package(
      name: "swift-composable-architecture",
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      branch: "protocol-beta"
    ),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
    .package(url: "https://github.com/pointfreeco/composable-core-location.git", from: "0.1.0"),
    .package(
      name: "SnapshotTesting",
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      .exact("1.8.2")
    ),
    .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.1.0"),
    .package(url: "https://github.com/vtourraine/AcknowList.git", .upToNextMajor(from: "2.1.0")),
    .package(url: "https://github.com/adamfootdev/BottomSheet.git", from: "0.1.3")
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
        "ApiClient",
        "Helpers",
        "FileClient",
        "GuideFeature",
        "Logger",
        "L10n",
        "IDProvider",
        "MapFeature",
        "NextRideFeature",
        "PathMonitorClient",
        "SettingsFeature",
        "SharedEnvironment",
        "SocialFeature",
        "Styleguide",
        "UserDefaultsClient",
        "UIApplicationClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "BottomSheet", package: "BottomSheet")
      ]
    ),
    .target(
      name: "ChatFeature",
      dependencies: [
        "ApiClient",
        "Helpers",
        "IDProvider",
        "L10n",
        "Logger",
        "SharedEnvironment",
        "SharedModels",
        "Styleguide",
        "SwiftUIHelpers",
        "UserDefaultsClient"
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
        "Styleguide",
        "SwiftUIHelpers"
      ]
    ),
    .target(
      name: "Helpers",
      dependencies: [
        "Styleguide",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "IDProvider",
      dependencies: ["Helpers"]
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
        "ApiClient",
        "Helpers",
        "L10n",
        "Logger",
        "NextRideFeature",
        "SharedEnvironment",
        "SharedModels",
        "Styleguide",
        "SwiftUIHelpers",
        .product(name: "ComposableCoreLocation", package: "composable-core-location"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "NextRideFeature",
      dependencies: [
        "ApiClient",
        "Helpers",
        "L10n",
        "Logger",
        "SharedModels",
        "Styleguide",
        "UserDefaultsClient",
        .product(name: "ComposableCoreLocation", package: "composable-core-location"),
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
        "SwiftUIHelpers",
        "UIApplicationClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "AcknowList", package: "AcknowList")
      ],
      resources: [.process("Resources/")]
    ),
    .target(
      name: "SharedEnvironment",
      dependencies: [
        "ApiClient",
        "IDProvider",
        "UIApplicationClient",
        "UserDefaultsClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        "Helpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "SocialFeature",
      dependencies: [
        "ChatFeature",
        "L10n",
        "TwitterFeedFeature",
        "UserDefaultsClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "Styleguide",
      dependencies: [
        "L10n",
        "SwiftUIHelpers"
      ],
      exclude: ["README.md"],
      resources: [.process("Resources")]
    ),
    .target(
      name: "SwiftUIHelpers",
      dependencies: []
    ),
    .target(
      name: "TestHelper",
      dependencies: [
        .product(name: "SnapshotTesting", package: "SnapshotTesting")
      ]
    ),
    .target(
      name: "TwitterFeedFeature",
      dependencies: [
        "ApiClient",
        "Logger",
        "SharedEnvironment",
        "SharedModels",
        "Styleguide",
        "UIApplicationClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
    )
  ]
)

// MARK: - Test Targets

package.targets.append(contentsOf: [
  .testTarget(
    name: "AppFeatureTests",
    dependencies: [
      "AppFeature",
      "PathMonitorClient",
      "TestHelper",
      .product(
        name: "ComposableArchitecture",
        package: "swift-composable-architecture"
      ),
      .product(name: "CustomDump", package: "swift-custom-dump")
    ],
    exclude: [
      "__Snapshots__"
    ]
  ),
  .testTarget(
    name: "ChatFeatureTests",
    dependencies: [
      "ChatFeature",
      "TestHelper",
      "SharedModels",
      "UserDefaultsClient",
      .product(name: "CustomDump", package: "swift-custom-dump")
    ],
    exclude: [
      "__Snapshots__"
    ]
  ),
  .testTarget(
    name: "HelperTests",
    dependencies: [
      "Helpers",
      "UserDefaultsClient"
    ]
  ),
  .testTarget(
    name: "IDProviderTests",
    dependencies: ["IDProvider"]
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
    name: "SocialFeatureTests",
    dependencies: [
      "SocialFeature",
      "TestHelper",
      .product(name: "CustomDump", package: "swift-custom-dump")
    ]
  ),
  .testTarget(
    name: "StyleguideTests",
    dependencies: [
      "Styleguide",
      "TestHelper",
      .product(name: "CustomDump", package: "swift-custom-dump")
    ],
    exclude: ["__Snapshots__"]
  ),
  .testTarget(
    name: "SettingsFeatureTests",
    dependencies: [
      "Helpers",
      "L10n",
      "SettingsFeature",
      "TestHelper",
      "UserDefaultsClient",
      .product(
        name: "ComposableArchitecture",
        package: "swift-composable-architecture"
      )
    ],
    exclude: ["__Snapshots__"]
  ),
  .testTarget(
    name: "TwitterFeedFeatureTests",
    dependencies: [
      "Helpers",
      "SharedEnvironment",
      "TwitterFeedFeature",
      "TestHelper",
      .product(
        name: "ComposableArchitecture",
        package: "swift-composable-architecture"
      )
    ],
    exclude: [
      "__Snapshots__"
    ]
  )
])
