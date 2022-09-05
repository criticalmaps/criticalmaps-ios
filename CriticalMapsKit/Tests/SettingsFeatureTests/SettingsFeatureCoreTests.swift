import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class SettingsFeatureCoreTests: XCTestCase {
  var defaultEnvironment = SettingsFeature.Environment(
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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.InfoSectionRow.privacy

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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.InfoSectionRow.website

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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.InfoSectionRow.twitter

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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.SupportSectionRow.github

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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.SupportSectionRow.crowdin

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
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature.reducer,
      environment: env
    )
    
    let row = SettingsFeature.State.SupportSectionRow.criticalMassDotIn

    store.send(.supportSectionRowTapped(row))
    store.receive(.openURL(row.url))

    XCTAssertEqual(openedUrl, row.url)
  }
}
