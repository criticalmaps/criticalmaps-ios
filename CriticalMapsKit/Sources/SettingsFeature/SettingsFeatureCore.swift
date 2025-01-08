import AcknowList
import ComposableArchitecture
import FileClient
import Helpers
import SharedDependencies
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

public struct SettingsFeature: Reducer {
  public init() {}

  // MARK: State

  @Dependency(\.continuousClock) var clock
  @Dependency(\.fileClient) var fileClient
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  
  @ObservableState public struct State: Equatable {
    public var isObservationModeEnabled = true
    public var infoViewEnabled = true
    public var rideEventSettings: RideEventsSettingsFeature.State
    public var appearanceSettings: AppearanceSettingsFeature.State

    public init(userSettings: UserSettings = .init()) {
      self.isObservationModeEnabled = userSettings.isObservationModeEnabled
      self.infoViewEnabled = userSettings.showInfoViewEnabled
      self.rideEventSettings = .init(settings: userSettings.rideEventSettings)
      self.appearanceSettings = .init(
        appIcon: userSettings.appearanceSettings.appIcon,
        colorScheme: userSettings.appearanceSettings.colorScheme
      )
    }

    var versionNumber: String { "\(Bundle.main.versionNumber)" }
    var buildNumber: String { "\(Bundle.main.buildNumber)" }
    var packageList: AcknowList? {
      guard
        let url = Bundle.module.url(forResource: "Package", withExtension: "resolved"),
        let data = try? Data(contentsOf: url)
      else {
        return nil
      }
      return try? AcknowPackageDecoder().decode(from: data)
    }
  }

  // MARK: Actions

  @CasePathable
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

  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Scope(state: \.appearanceSettings, action: \.appearance) {
      AppearanceSettingsFeature()
    }

    Scope(state: \.rideEventSettings, action: \.rideevent) {
      RideEventsSettingsFeature()
    }

    Reduce { state, action in
      switch action {
      case .onAppear:
        state.appearanceSettings.appIcon = uiApplicationClient.alternateIconName()
          .flatMap(AppIcon.init(rawValue:)) ?? .appIcon2
        state.isObservationModeEnabled = observationModeStore.getObservationModeState()
        return .none
        
      case let .infoSectionRowTapped(row):
        return .send(.openURL(row.url))

      case let .supportSectionRowTapped(row):
        return .send(.openURL(row.url))

      case let .openURL(url):
        return .run { _ in
          _ = await uiApplicationClient.open(url, [:])
        }

      case .appearance, .rideevent, .binding(\.isObservationModeEnabled), .binding(\.infoViewEnabled):
        enum CancelID { case debounce }
        
        return .run { [settings = state] _ in
          try await withTaskCancellation(
            id: CancelID.debounce,
            cancelInFlight: true)
          {
            try await clock.sleep(for: .seconds(1.5))
            try await fileClient.saveUserSettings(
              userSettings: .init(settings: settings)
            )
            observationModeStore.setObservationModeState(isEnabled: settings.isObservationModeEnabled)
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
    case website, mastodon, privacy

    public var url: URL {
      switch self {
      case .website:
        return URL(string: "https://www.criticalmaps.net")!
      case .mastodon:
        return URL(string: "https://mastodon.social/@criticalmaps")!
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
