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
    @BindingState public var isObservationModeEnabled = true
    @BindingState public var infoViewEnabled = true
    public var rideEventSettings: RideEventsSettingsFeature.State
    public var appearanceSettings: AppearanceSettingsFeature.State

    public init(userSettings: UserSettings = .init()) {
      self.isObservationModeEnabled = userSettings.isObservationModeEnabled
      self.rideEventSettings = .init(settings: userSettings.rideEventSettings)
      self.appearanceSettings = .init(
        appIcon: userSettings.appearanceSettings.appIcon,
        colorScheme: userSettings.appearanceSettings.colorScheme
      )
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

  public enum Action: BindableAction, Equatable {
    case onAppear
    case binding(BindingAction<State>)
    case supportSectionRowTapped(SettingsFeature.State.SupportSectionRow)
    case infoSectionRowTapped(SettingsFeature.State.InfoSectionRow)
    case openURL(URL)

    case appearance(AppearanceSettingsFeature.Action)
    case rideevent(RideEventsSettingsFeature.Action)
  }

  // MARK: Reducer

  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Scope(
      state: \.appearanceSettings,
      action: /SettingsFeature.Action.appearance
    ) {
      AppearanceSettingsFeature()
    }

    Scope(
      state: \.rideEventSettings,
      action: /SettingsFeature.Action.rideevent) {
        RideEventsSettingsFeature()
    }

    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        state.appearanceSettings.appIcon = uiApplicationClient.alternateIconName()
          .flatMap(AppIcon.init(rawValue:)) ?? .appIcon2
        return .none

      case let .infoSectionRowTapped(row):
        return EffectTask(value: .openURL(row.url))

      case let .supportSectionRowTapped(row):
        return EffectTask(value: .openURL(row.url))

      case let .openURL(url):
        return .fireAndForget {
          _ = await uiApplicationClient.open(url, [:])
        }

      case .appearance, .rideevent, .binding(\.$isObservationModeEnabled), .binding(\.$infoViewEnabled):
        enum SaveDebounceId { case debounce }
        
        return .fireAndForget { [settings = state] in
          try await withTaskCancellation(id: SaveDebounceId.debounce, cancelInFlight: true) {
            try await mainQueue.sleep(for: .seconds(1))
            try await fileClient.saveUserSettings(
              userSettings: .init(settings: settings)
            )
          }
        }
        
      case .binding:
        return .none
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

extension UserSettings {
  init(settings: SettingsFeature.State) {
    self.init(
      appearanceSettings: settings.appearanceSettings,
      enableObservationMode: settings.isObservationModeEnabled,
      showInfoViewEnabled: settings.infoViewEnabled,
      rideEventSettings: .init(settings.rideEventSettings)
    )
  }
}

extension RideEventSettings {
  public init(_ featureSettings: RideEventsSettingsFeature.State) {
    self.init(
      isEnabled: featureSettings.isEnabled,
      typeSettings: featureSettings.rideEventTypes.elements.reduce(into: [Ride.RideType: Bool]()) { result, property in
        result[property.rideType] = property.isEnabled
      },
      eventDistance: featureSettings.eventSearchRadius
    )
  }
}
