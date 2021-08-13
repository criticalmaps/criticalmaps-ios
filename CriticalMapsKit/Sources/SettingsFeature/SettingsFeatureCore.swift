import ComposableArchitecture
import Helpers
import UIApplicationClient

// MARK: State
public struct SettingsState: Equatable {
  public init() {}
  
  var versionNumber: String {
    "Critical Maps \(Bundle.main.versionNumber)"
  }
  var buildNumber: String {
    "Build \(Bundle.main.buildNumber)"
  }
}

public extension SettingsState { }

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
  case supportSectionRowTapped(SettingsState.SupportSectionRow)
  case infoSectionRowTapped(SettingsState.InfoSectionRow)
  case openURL(URL)
}


// MARK: Environment
public struct SettingsEnvironment {
  public var uiApplicationClient: UIApplicationClient

  public init(uiApplicationClient: UIApplicationClient) {
    self.uiApplicationClient = uiApplicationClient
  }
}


public let settingsReducer = Reducer<SettingsState, SettingsAction, SettingsEnvironment> { state, action, environment in
  switch action {
  case let .infoSectionRowTapped(row):
    return Effect(value: .openURL(row.url))
  
  case let .supportSectionRowTapped(row):
    return Effect(value: .openURL(row.url))
    
  case let .openURL(url):
    return environment.uiApplicationClient
      .open(url, [:])
      .fireAndForget()
  }
}

