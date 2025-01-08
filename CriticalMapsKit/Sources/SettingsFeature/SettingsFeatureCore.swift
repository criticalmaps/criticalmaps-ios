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

  @Reducer
  public enum Destination {
    case rideEvents(RideEventsSettingsFeature)
    case appearance(AppearanceSettingsFeature)
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.fileClient) var fileClient
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  
  // MARK: State

  @ObservableState
  public struct State {
    @ObservationStateIgnored
    @Shared(.fileStorage(.userSettingsURL))
    public var userSettings = UserSettings()
        
    @Presents
    var destination: Destination.State?

    public init() {}
    
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
  public enum Action: BindableAction {
    case onAppear
    case binding(BindingAction<State>)
    case supportSectionRowTapped(SettingsFeature.State.SupportSectionRow)
    case infoSectionRowTapped(SettingsFeature.State.InfoSectionRow)
    case openURL(URL)
    case destination(PresentationAction<Destination.Action>)
    case appearanceSettingsRowTapped
    case rideEventSettingsRowTapped
  }

  // MARK: Reducer

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .onAppear:
        state.userSettings.appearanceSettings.appIcon = uiApplicationClient.alternateIconName()
          .flatMap(AppIcon.init(rawValue:)) ?? .appIcon2
        return .none
        
      case .appearanceSettingsRowTapped:
        state.destination = .appearance(AppearanceSettingsFeature.State())
        return .none
        
      case .rideEventSettingsRowTapped:
        state.destination = .rideEvents(RideEventsSettingsFeature.State(settings: state.userSettings.rideEventSettings))
        return .none

      case .destination:
        return .none
    
        
      case let .infoSectionRowTapped(row):
        return .send(.openURL(row.url))

      case let .supportSectionRowTapped(row):
        return .send(.openURL(row.url))

      case let .openURL(url):
        return .run { _ in
          _ = await uiApplicationClient.open(url, [:])
        }
        
      case .binding:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
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
