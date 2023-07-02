import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

@MainActor
final class SettingsFeatureCoreTests: XCTestCase {
  func test_openURLAction_shouldCallUIApplicationClient_privacy() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.privacy

    await store.send(.infoSectionRowTapped(row))
    await store.receive(.openURL(row.url))
    
    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_cmWebsite() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.website

    await store.send(.infoSectionRowTapped(row))
    await store.receive(.openURL(row.url))
    
    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_cmTwitter() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.twitter

    await store.send(.infoSectionRowTapped(row))
    await store.receive(.openURL(row.url))

    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_github() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.github

    await store.send(.supportSectionRowTapped(row))
    await store.receive(.openURL(row.url))

    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_crowdin() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.crowdin

    await store.send(.supportSectionRowTapped(row))
    await store.receive(.openURL(row.url))
    
    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_openURLAction_shouldCallUIApplicationClient_criticalMassDotIn() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: SettingsFeature()
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.criticalMassDotIn

    await store.send(.supportSectionRowTapped(row))
    await store.receive(.openURL(row.url))

    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  func test_didSaveUserSettings_onRideEventSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let testQueue = DispatchQueue.immediate

    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(
          rideEventSettings: .init(eventDistance: .close)
        )
      ),
      reducer: SettingsFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    
    // act
    await store.send(.rideevent(.set(\.$eventSearchRadius, .far))) {
      $0.rideEventSettings.eventSearchRadius = .far
    }

    // assert
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
  }
  
  func test_didSaveUserSettings_onAppearanceSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let testQueue = DispatchQueue.immediate

    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(
          appearanceSettings: .init(
            appIcon: .appIcon1,
            colorScheme: .light
          )
        )
      ),
      reducer: SettingsFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    
    // act
    await store.send(.appearance(.set(\.$colorScheme, .dark))) {
      $0.appearanceSettings.colorScheme = .dark
    }

    // assert
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
  }
  
  func test_didSaveUserSettings_onSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let testQueue = DispatchQueue.immediate

    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(enableObservationMode: false)
      ),
      reducer: SettingsFeature()
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    
    // act
    await store.send(.set(\.$isObservationModeEnabled, true)) {
      $0.isObservationModeEnabled = true
    }

    // assert
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
  }
}
