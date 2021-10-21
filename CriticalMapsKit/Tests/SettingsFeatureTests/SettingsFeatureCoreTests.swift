import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

class SettingsFeatureCoreTests: XCTestCase {
  var defaultEnvironment = SettingsEnvironment(
    uiApplicationClient: .noop,
    setUserInterfaceStyle: { _ in .none},
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
    store.assert(
      .send(.infoSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
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
    store.assert(
      .send(.infoSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
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
    store.assert(
      .send(.infoSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
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
    store.assert(
      .send(.supportSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
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
    store.assert(
      .send(.supportSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
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
    store.assert(
      .send(.supportSectionRowTapped(row)),
      .receive(.openURL(row.url))
    )
    XCTAssertEqual(openedUrl, row.url)
  }
  
  // MARK: - RideEvent Settings
  func test_setRideEventsEnabled() {
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: defaultEnvironment
    )
    
    store.send(.setRideEventsEnabled(false)) {
      $0.userSettings.rideEventSettings.isEnabled = false
    }
    
    store.send(.setRideEventsEnabled(true)) {
      $0.userSettings.rideEventSettings.isEnabled = true
    }
  }
  
  func test_setRideEventsTypeEnabled() {
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: defaultEnvironment
    )
    
    var updatedType = RideEventSettings.RideEventTypeSetting(type: .kidicalMass, isEnabled: false)
    store.send(.setRideEventTypeEnabled(updatedType)) {
      var updatedSettings: [RideEventSettings.RideEventTypeSetting] = .all
      let index = try XCTUnwrap(updatedSettings.firstIndex(where: { setting in
        setting.type == updatedType.type
      }))
      updatedSettings[index] = updatedType
      $0.userSettings.rideEventSettings.typeSettings = updatedSettings
    }
    
    updatedType.isEnabled = true
    store.send(.setRideEventTypeEnabled(updatedType)) {
      $0.userSettings.rideEventSettings.typeSettings = .all
    }
  }
  
  func test_setRideEventsRadius() {
    let store = TestStore(
      initialState: SettingsState(),
      reducer: settingsReducer,
      environment: defaultEnvironment
    )
    
    store.send(.setRideEventRadius(5)) {
      $0.userSettings.rideEventSettings.radiusSettings = 5
    }
  }
}
