import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

class SettingsFeatureCoreTests: XCTestCase {
  var defaultEnvironment = SettingsEnvironment(
    uiApplicationClient: .noop,
    setUserInterfaceStyle: { _ in .none },
    fileClient: .noop,
    backgroundQueue: .immediate,
    mainQueue: .immediate
  )
  
  func test_openURLAction_shouldCallUIApplicationClient_privacy() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.InfoSectionRow.privacy

    store.send(.infoSectionRowTapped(row))
    store.receive(.openURL(row.url))
    
    XCTAssertEqual(openedUrl, row.url)
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_cmWebsite() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.InfoSectionRow.website

    store.send(.infoSectionRowTapped(row))
    store.receive(.openURL(row.url))
    
    XCTAssertEqual(openedUrl, row.url)
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_cmTwitter() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.InfoSectionRow.twitter

    store.send(.infoSectionRowTapped(row))
    store.receive(.openURL(row.url))

    XCTAssertEqual(openedUrl, row.url)
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_github() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.SupportSectionRow.github

    store.send(.supportSectionRowTapped(row))
    store.receive(.openURL(row.url))

    XCTAssertEqual(openedUrl, row.url)
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_crowdin() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.SupportSectionRow.crowdin

    store.send(.supportSectionRowTapped(row))
    store.receive(.openURL(row.url))
    
    XCTAssertEqual(openedUrl, row.url)
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_criticalMassDotIn() {
    var openedUrl: URL!
    
    var env = defaultEnvironment
    env.uiApplicationClient.open = { url, _ in
      openedUrl = url
      return .init(value: true)
    }
    
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: env
    )
    
    let row = SettingsState.SupportSectionRow.criticalMassDotIn

    store.send(.supportSectionRowTapped(row))
    store.receive(.openURL(row.url))

    XCTAssertEqual(openedUrl, row.url)
  }
}
