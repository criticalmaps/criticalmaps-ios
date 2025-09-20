import AppIntents
import Foundation
import SharedModels
import Sharing

public struct ObservationModeIntent: AppIntent {
  public static var title = LocalizedStringResource(
    "appIntent.observationMode.title",
    defaultValue: "Toggle Observation Mode",
    bundle: .module
  )
  public static var description = IntentDescription(
    LocalizedStringResource(
      "appIntent.observationMode.description",
      defaultValue: "Enable or disable observation mode in CriticalMaps",
      bundle: .module
    )
  )

  @Parameter(
    title: LocalizedStringResource(
      "appIntent.observationMode.parameter.title",
      defaultValue: "Enable Observation Mode",
      bundle: .module
    ),
    description: LocalizedStringResource(
      "appIntent.observationMode.parameter.description",
      defaultValue: "Whether to enable or disable observation mode",
      bundle: .module
    )
  )
  public var enableObservationMode: Bool

  public init() {}

  public init(enableObservationMode: Bool) {
    self.enableObservationMode = enableObservationMode
  }

  public func perform() async throws -> some IntentResult & ProvidesDialog {
    // Update the user settings
    @Shared(.userSettings) var userSettings
    $userSettings.withLock { $0.isObservationModeEnabled = enableObservationMode }

    let statusMessage = userSettings.isObservationModeEnabled
      ? String(
        localized: "appIntent.observationMode.result.enabled",
        defaultValue: "Observation mode enabled",
        bundle: .module
      )
      : String(
        localized: "appIntent.observationMode.result.disabled",
        defaultValue: "Observation mode disabled",
        bundle: .module
      )

    return .result(dialog: IntentDialog(stringLiteral: statusMessage))
  }
}
