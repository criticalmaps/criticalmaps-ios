import AcknowList
import ComposableArchitecture
import ComposableCoreLocation
import Helpers
import MapFeature
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

@Reducer
public struct SettingsFeature: Sendable {
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
  public struct State: Equatable, Sendable {
    @Shared(.userSettings) public var userSettings
    @Shared(.rideEventSettings) public var rideEventSettings
    @Shared(.appearanceSettings) public var appearanceSettings

    @Presents
    var destination: Destination.State?

    public var isImportingGPXRoute = false

    public init() {}

    var versionNumber: String {
      "\(Bundle.main.versionNumber)"
    }

    var buildNumber: String {
      "\(Bundle.main.buildNumber)"
    }

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
    case gpxRouteParsed(GPXRoute)

    public enum ViewAction {
      case acknowledgementsRowTapped
      case appearanceSettingsRowTapped
      case dismiss
      case guideRowTapped
      case onAppear
      case rideEventSettingsRowTapped
      case privacyZonesRowTapped
      case observationModeChanged(Bool)
      case infoSectionRowTapped(SettingsFeature.State.InfoSectionRow)
      case supportSectionRowTapped(SettingsFeature.State.SupportSectionRow)
      case gpxImportButtonTapped
      case gpxFileSelected(Result<URL, any Error>)
      case gpxRouteRemoved
    }
  }

  // MARK: Reducer

  @Dependency(\.continuousClock) var clock
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  @Dependency(\.locationManager) var locationManager
  @Dependency(\.dismiss) var dismiss

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case let .view(viewAction):
        switch viewAction {
        case .onAppear:
          return .publisher {
            state.$userSettings.publisher
              .map(\.isObservationModeEnabled)
              .removeDuplicates()
              .map { .view(.observationModeChanged($0)) }
          }
					
        case .dismiss:
          return .run { _ in await dismiss() }
					
        case let .observationModeChanged(isObserving):
          guard isObserving != state.userSettings.isObservationModeEnabled else {
            return .none
          }
          if isObserving {
            locationManager.stopUpdatingLocation()
          } else {
            locationManager.startUpdatingLocation()
          }
          return .none

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

        case .gpxImportButtonTapped:
          state.isImportingGPXRoute = true
          return .none

        case let .gpxFileSelected(result):
          state.isImportingGPXRoute = false
          guard case let .success(url) = result else { return .none }
          return .run { send in
            let accessing = url.startAccessingSecurityScopedResource()
            defer { if accessing { url.stopAccessingSecurityScopedResource() } }
            guard
              let data = try? Data(contentsOf: url),
              var route = GPXParser.parse(data: data)
            else { return }
            route.name = url.lastPathComponent
            await send(.gpxRouteParsed(route))
          }

        case .gpxRouteRemoved:
          state.$userSettings.withLock { $0.gpxRoute = nil }
          return .none
        }

      case .destination:
        return .none

      case let .openURL(url):
        return .run { _ in
          _ = await uiApplicationClient.open(url, [:])
        }

      case let .gpxRouteParsed(route):
        state.$userSettings.withLock { $0.gpxRoute = route }
        return .none

      case .binding:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

extension SettingsFeature.Destination.State: Equatable, Sendable {}

// MARK: Helper

public extension SettingsFeature.State {
  enum InfoSectionRow: Equatable, Sendable {
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

  enum SupportSectionRow: Equatable, Sendable {
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
