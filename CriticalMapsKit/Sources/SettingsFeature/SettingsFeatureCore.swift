import ComposableArchitecture
import FileClient
import Helpers
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

public struct SettingsFeature: ReducerProtocol {
  public init() {}

  // MARK: State

  @Dependency(\.fileClient) public var fileClient
  @Dependency(\.mainQueue) public var mainQueue
  @Dependency(\.uiApplicationClient) public var uiApplicationClient

  public struct State: Equatable {
    public var userSettings: UserSettings

    public init(
      userSettings: UserSettings = UserSettings()
    ) {
      self.userSettings = userSettings
    }

    var versionNumber: String { "Critical Maps \(Bundle.main.versionNumber)" }
    var buildNumber: String { "Build \(Bundle.main.buildNumber)" }
    var acknowledgementsPlistPath: String? {
      guard let path = Bundle.module.path(forResource: "Acknowledgements", ofType: "plist") else {
        return nil
      }
      return path
    }
  }

  // MARK: Actions

  public enum Action: Equatable {
    case onAppear
    case binding(BindingAction<State>)
    case supportSectionRowTapped(SettingsFeature.State.SupportSectionRow)
    case infoSectionRowTapped(SettingsFeature.State.InfoSectionRow)
    case setObservationMode(Bool)
    case openURL(URL)

    case appearance(AppearanceSettingsFeature.Action)
    case rideevent(RideEventsSettingsFeature.Action)
  }

  // MARK: Reducer

  public var body: some ReducerProtocol<State, Action> {
    Scope(
      state: \.userSettings.appearanceSettings,
      action: /SettingsFeature.Action.appearance
    ) {
      AppearanceSettingsFeature()
    }

    Scope(state: \.userSettings.rideEventSettings, action: /SettingsFeature.Action.rideevent) {
      RideEventsSettingsFeature()
    }

    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        state.userSettings.appearanceSettings.appIcon = uiApplicationClient.alternateIconName()
          .flatMap(AppIcon.init(rawValue:)) ?? .appIcon2
        return .none

      case let .infoSectionRowTapped(row):
        return EffectTask(value: .openURL(row.url))

      case let .supportSectionRowTapped(row):
        return EffectTask(value: .openURL(row.url))

      case let .openURL(url):
        return .fireAndForget {
          await uiApplicationClient.open(url, [:])
        }

      case let .setObservationMode(value):
        state.userSettings.isObservationModeEnabled = value
        return .none

      case .binding:
        return .none

      case .appearance, .rideevent:
        enum SaveDebounceId {}

        let userSettings = state.userSettings
        return .fireAndForget {
          try await withTaskCancellation(id: SaveDebounceId.self, cancelInFlight: true) {
            try await mainQueue.sleep(for: .seconds(0.3))
            try await fileClient.saveUserSettings(userSettings: userSettings)
          }
        }
      }
    }
  }
}

// MARK: Helper

public extension SettingsFeature.State {
  enum InfoSectionRow: Equatable {
    case website, twitter, privacy

    public var url: URL {
      switch self {
      case .website:
        return URL(string: "https://www.criticalmaps.net")!
      case .twitter:
        return URL(string: "https://twitter.com/criticalmaps/")!
      case .privacy:
        return URL(string: "https://www.criticalmaps.net/info")!
      }
    }
  }

  enum SupportSectionRow: Equatable {
    case github, criticalMassDotIn, crowdin

    public var url: URL {
      switch self {
      case .github:
        return URL(string: "https://github.com/criticalmaps/criticalmaps-ios")!
      case .criticalMassDotIn:
        return URL(string: "https://criticalmass.in")!
      case .crowdin:
        return URL(string: "https://crowdin.com/project/critical-maps")!
      }
    }
  }
}
