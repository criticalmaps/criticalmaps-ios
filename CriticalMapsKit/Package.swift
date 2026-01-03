// swift-tools-version:6.2

import PackageDescription

let package = Package(
  name: "CriticalMapsKit",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .singleTargetLibrary("ApiClient"),
    .singleTargetLibrary("AppFeature"),
    .singleTargetLibrary("AppIntentFeature"),
    .singleTargetLibrary("ChatFeature"),
    .singleTargetLibrary("GuideFeature"),
    .singleTargetLibrary("MapFeature"),
    .singleTargetLibrary("SettingsFeature"),
    .singleTargetLibrary("MastodonFeedFeature"),
    .singleTargetLibrary("SocialFeature"),
    .singleTargetLibrary("Styleguide")
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "1.0.0"
    ),
    .package(
      url: "https://github.com/mltbnz/composable-core-location",
      branch: "main"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
      .upToNextMajor(from: "1.8.2")
    ),
    .package(
      url: "https://github.com/mltbnz/AcknowList",
      branch: "main"
    ),
    .package(
      url: "https://github.com/mltbnz/MastodonKit.git",
      branch: "master"
    )
  ],
  targets: [
    .target(
      name: "ApiClient",
      dependencies: [
        .helpers,
        .sharedModels
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        .apiClient,
        .helpers,
        .feedbackGeneratorClient,
        "GuideFeature",
        .l10n,
        .idProvider,
        "MapFeature",
        "NextRideFeature",
        .pathMonitorClient,
        "SettingsFeature",
        "SocialFeature",
        .styleguide,
        .userDefaultsClient,
        .uiApplicationClient,
        .tca
      ]
    ),
    .target(
      name: "AppIntentFeature",
      dependencies: [
        .sharedModels,
        .tca
      ]
    ),
    .target(
      name: "ChatFeature",
      dependencies: [
        .apiClient,
        .helpers,
        .idProvider,
        .l10n,
        .sharedModels,
        .styleguide,
        .swiftUIHelpers,
        .userDefaultsClient
      ]
    ),
    .target(
      name: "FeedbackGeneratorClient",
      dependencies: [.tca]
    ),
    .target(
      name: "GuideFeature",
      dependencies: [
        .helpers,
        .l10n,
        .styleguide,
        .swiftUIHelpers
      ]
    ),
    .target(
      name: "Helpers",
      dependencies: [
        .styleguide,
        .tca
      ]
    ),
    .target(
      name: "IDProvider",
      dependencies: [
        .helpers,
        .tca,
        .userDefaultsClient
      ]
    ),
    .target(
      name: "L10n",
      dependencies: [],
      resources: [.process("Resources")]
    ),
    .target(
      name: "MapFeature",
      dependencies: [
        .apiClient,
        .helpers,
        .l10n,
        "NextRideFeature",
        .sharedModels,
        .styleguide,
        .swiftUIHelpers,
        .composableCoreLocation,
        .tca
      ]
    ),
    .target(
      name: "MastodonFeedFeature",
      dependencies: [
        .apiClient,
        .sharedModels,
        .styleguide,
        .uiApplicationClient,
        .tca,
        .product(name: "MastodonKit", package: "MastodonKit")
      ]
    ),
    .target(
      name: "NextRideFeature",
      dependencies: [
        .apiClient,
        .helpers,
        .l10n,
        .sharedModels,
        .styleguide,
        .userDefaultsClient,
        .composableCoreLocation,
        .tca
      ]
    ),
    .target(
      name: "PathMonitorClient",
      dependencies: [
        .tca
      ]
    ),
    .target(
      name: "SettingsFeature",
      dependencies: [
        .feedbackGeneratorClient,
        "GuideFeature",
        .l10n,
        .helpers,
        "MapFeature",
        .sharedModels,
        .styleguide,
        .swiftUIHelpers,
        .uiApplicationClient,
        .tca,
        .product(name: "AcknowList", package: "AcknowList")
      ],
      resources: [.process("_Resources/")]
    ),
    .target(
      name: "SharedKeys",
      dependencies: [
        .sharedModels,
        .tca
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [
        .helpers,
        .tca
      ]
    ),
    .target(
      name: "SocialFeature",
      dependencies: [
        "ChatFeature",
        .l10n,
        "MastodonFeedFeature",
        .userDefaultsClient,
        .tca
      ]
    ),
    .target(
      name: "Styleguide",
      dependencies: [
        .l10n,
        .tca,
        .swiftUIHelpers
      ],
      exclude: ["README.md"],
      resources: [.process("Resources")],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
    .target(
      name: "SwiftUIHelpers",
      dependencies: []
    ),
    .target(
      name: "TestHelper",
      dependencies: [
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
      ]
    ),
    .target(
      name: "UIApplicationClient",
      dependencies: [
        .tca
      ]
    ),
    .target(
      name: "UserDefaultsClient",
      dependencies: [
        .helpers,
        .sharedModels,
        .tca
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
      .pathMonitorClient,
      .testHelper,
      .tca
    ],
    exclude: [
      "__Snapshots__"
    ]
  ),
  .testTarget(
    name: "ChatFeatureTests",
    dependencies: [
      "ChatFeature",
      .testHelper,
      .sharedModels,
      .userDefaultsClient,
      .tca
    ],
    exclude: [
      "__Snapshots__"
    ]
  ),
  .testTarget(
    name: "HelperTests",
    dependencies: [
      .helpers,
      .userDefaultsClient
    ]
  ),
  .testTarget(
    name: "IDProviderTests",
    dependencies: [.idProvider]
  ),
  .testTarget(
    name: "MapFeatureTests",
    dependencies: [
      "MapFeature",
      .testHelper,
      .tca
    ],
    exclude: [
      "__Snapshots__"
    ]
  ),
  .testTarget(
    name: "NextRideFeatureTests",
    dependencies: [
      .helpers,
      .userDefaultsClient,
      "NextRideFeature",
      .tca
    ]
  ),
  .testTarget(
    name: "SocialFeatureTests",
    dependencies: [
      "SocialFeature",
      .testHelper,
      .tca
    ]
  ),
  .testTarget(
    name: "StyleguideTests",
    dependencies: [
      .styleguide,
      .testHelper,
      .tca
    ],
    exclude: ["__Snapshots__"]
  ),
  .testTarget(
    name: "SettingsFeatureTests",
    dependencies: [
      .helpers,
      .l10n,
      "SettingsFeature",
      .testHelper,
      .userDefaultsClient,
      .tca
    ],
    exclude: ["__Snapshots__"]
  ),
  .testTarget(
    name: "MastodonFeedFeatureTests",
    dependencies: [
      .helpers,
      "MastodonFeedFeature",
      .testHelper,
      .tca,
      .product(name: "MastodonKit", package: "MastodonKit")
    ]
  )
])

extension Target.Dependency {
  // MARK: - Internal

  static let apiClient = byName(name: "ApiClient")
  static let feedbackGeneratorClient = byName(name: "FeedbackGeneratorClient")
  static let helpers = byName(name: "Helpers")
  static let idProvider = byName(name: "IDProvider")
  static let l10n = byName(name: "L10n")
  static let pathMonitorClient = byName(name: "PathMonitorClient")
  static let sharedKeys = byName(name: "SharedKeys")
  static let sharedModels = byName(name: "SharedModels")
  static let styleguide = byName(name: "Styleguide")
  static let swiftUIHelpers = byName(name: "SwiftUIHelpers")
  static let testHelper = byName(name: "TestHelper")
  static let uiApplicationClient = byName(name: "UIApplicationClient")
  static let userDefaultsClient = byName(name: "UserDefaultsClient")

  // MARK: - External

  static let tca = product(
    name: "ComposableArchitecture",
    package: "swift-composable-architecture"
  )
  static let composableCoreLocation = product(
    name: "ComposableCoreLocation",
    package: "composable-core-location"
  )
}

extension Product {
  static func singleTargetLibrary(_ name: String) -> Product {
    .library(name: name, targets: [name])
  }
}
