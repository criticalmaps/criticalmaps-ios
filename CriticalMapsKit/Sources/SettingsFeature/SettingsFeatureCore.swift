import ComposableArchitecture
import FileClient
import Helpers
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

// MARK: State
public struct SettingsState: Equatable {
  public var userSettings: UserSettings
  
  public init(
    userSettings: UserSettings = UserSettings()
  ) {
    self.userSettings = userSettings
  }
  
  var versionNumber: String { "Critical Maps \(Bundle.main.versionNumber)" }
  var buildNumber: String { "Build \(Bundle.main.buildNumber)" }
}

public extension SettingsState {
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

// MARK: Actions
public enum SettingsAction: Equatable {
  case onAppear
  case binding(BindingAction<SettingsState>)
  case supportSectionRowTapped(SettingsState.SupportSectionRow)
  case infoSectionRowTapped(SettingsState.InfoSectionRow)
  case setObservationMode(Bool)
  case openURL(URL)
  
  case appearance(AppearanceSettingsAction)
  case rideevent(RideEventSettingsActions)
}


// MARK: Environment
public struct SettingsEnvironment {
  public let backgroundQueue: AnySchedulerOf<DispatchQueue>
  public var fileClient: FileClient
  public let mainQueue: AnySchedulerOf<DispatchQueue>
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>
  public var uiApplicationClient: UIApplicationClient
  
  public init(
    uiApplicationClient: UIApplicationClient,
    setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>,
    fileClient: FileClient,
    backgroundQueue: AnySchedulerOf<DispatchQueue>,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.uiApplicationClient = uiApplicationClient
    self.setUserInterfaceStyle = setUserInterfaceStyle
    self.fileClient = fileClient
    self.backgroundQueue = backgroundQueue
    self.mainQueue = mainQueue
  }
}

public let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    state.userSettings.appearanceSettings.appIcon = environment.uiApplicationClient.alternateIconName()
      .flatMap(AppIcon.init(rawValue:))
    return .none
  
  case let .infoSectionRowTapped(row):
    return Effect(value: .openURL(row.url))
  
  case let .supportSectionRowTapped(row):
    return Effect(value: .openURL(row.url))
    
  case let .openURL(url):
    return environment.uiApplicationClient
      .open(url, [:])
      .fireAndForget()

  case let .setObservationMode(value):
    state.userSettings.enableObservationMode = value
    return .none
    
  case .binding:
    return .none
    
  case .appearance, .rideevent:
    return .none
  }
}
.combined(
  with: appearanceSettingsReducer.pullback(
    state: \.userSettings.appearanceSettings,
    action: /SettingsAction.appearance,
    environment: { global in AppearanceSettingsEnvironment(
      uiApplicationClient: global.uiApplicationClient,
      setUserInterfaceStyle: global.setUserInterfaceStyle
    )
    }
  )
)
.combined(
  with: rideeventSettingsReducer.pullback(
    state: \.userSettings.rideEventSettings,
    action: /SettingsAction.rideevent,
    environment: { _ in .init() }
  )
)
.onChange(of: \.userSettings) { userSettings, _, _, environment in
  struct SaveDebounceId: Hashable {}

  return environment.fileClient
    .saveUserSettings(userSettings: userSettings, on: environment.backgroundQueue)
    .fireAndForget()
    .debounce(id: SaveDebounceId(), for: .seconds(1), scheduler: environment.mainQueue)
}
