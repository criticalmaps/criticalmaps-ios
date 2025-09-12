import AcknowList
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import Helpers
import MapFeature
import SharedDependencies
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

@Reducer
public struct SettingsFeature {
  public init() {}

  @Reducer
  public enum Destination {
    case rideEventSettings(RideEventsSettingsFeature)
    case appearanceSettings(AppearanceSettingsFeature)
    case privacyZonesSettings(PrivacyZoneFeature)
    case guideFeature
    case acknowledgements
  }

  // MARK: State

  @ObservableState
  public struct State: Equatable {
    @Shared(.userSettings) public var userSettings
    @Shared(.rideEventSettings) public var rideEventSettings
    @Shared(.appearanceSettings) public var appearanceSettings

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
    case binding(BindingAction<State>)
    case view(ViewAction)
    case destination(PresentationAction<Destination.Action>)
    case openURL(URL)
    
    public enum ViewAction {
      case acknowledgementsRowTapped
      case appearanceSettingsRowTapped
      case dismiss
      case guideRowTapped
      case onAppear
      case rideEventSettingsRowTapped
      case privacyZonesRowTapped
      case infoSectionRowTapped(SettingsFeature.State.InfoSectionRow)
      case supportSectionRowTapped(SettingsFeature.State.SupportSectionRow)
    }
  }

  // MARK: Reducer

  @Dependency(\.continuousClock) var clock
  @Dependency(\.fileClient) var fileClient
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  @Dependency(\.locationManager) var locationManager
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
      .onChange(of: \.userSettings.isObservationModeEnabled) { _, newValue in
        Reduce { _, _ in
          .run { [isObserving = newValue] _ in
            if isObserving {
              await locationManager.stopUpdatingLocation()
            } else {
              await locationManager.startUpdatingLocation()
            }
          }
        }
      }

    Reduce { state, action in
      switch action {
      case let .view(viewAction):
        switch viewAction {
        case .onAppear:
          return .none
  
        case .dismiss:
          return .run { _ in await dismiss() }
       
        case .acknowledgementsRowTapped:
          state.destination = .acknowledgements
          return .none
          
        case .guideRowTapped:
          state.destination = .guideFeature
          return .none
          
        case .appearanceSettingsRowTapped:
          state.destination = .appearanceSettings(
            AppearanceSettingsFeature.State(appearanceSettings: state.appearanceSettings)
          )
          return .none

        case .rideEventSettingsRowTapped:
          state.destination = .rideEventSettings(
            RideEventsSettingsFeature.State(settings: state.rideEventSettings)
          )
          return .none
          
        case .privacyZonesRowTapped:
          state.destination = .privacyZonesSettings(
            PrivacyZoneFeature.State()
          )
          return .none
          
        case let .infoSectionRowTapped(row):
          return .send(.openURL(row.url))

        case let .supportSectionRowTapped(row):
          return .send(.openURL(row.url))
        }

      case .destination:
        return .none

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

extension SettingsFeature.Destination.State: Equatable {}

// MARK: Helper

public extension SettingsFeature.State {
  enum InfoSectionRow: Equatable {
    case website, mastodon, privacy

    public var url: URL {
      switch self {
      case .website:
        URL(string: "https://www.criticalmaps.net")!
      case .mastodon:
        URL(string: "https://mastodon.social/@criticalmaps")!
      case .privacy:
        URL(string: "https://www.criticalmaps.net/info")!
      }
    }
  }

  enum SupportSectionRow: Equatable {
    case github, criticalMassDotIn, crowdin

    public var url: URL {
      switch self {
      case .github:
        URL(string: "https://github.com/criticalmaps/criticalmaps-ios")!
      case .criticalMassDotIn:
        URL(string: "https://criticalmass.in")!
      case .crowdin:
        URL(string: "https://crowdin.com/project/critical-maps")!
      }
    }
  }
}
