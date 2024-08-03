import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class SettingsFeatureCoreTests: XCTestCase {
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_privacy() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
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
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_cmWebsite() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
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
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_cmMastodon() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      await openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.mastodon

    await store.send(.infoSectionRowTapped(row))
    await store.receive(.openURL(row.url))

    await openedUrl.withValue { url in
      XCTAssertEqual(url, row.url)
    }
  }
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_github() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
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
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_crowdin() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
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
  
  @MainActor
  func test_openURLAction_shouldCallUIApplicationClient_criticalMassDotIn() async {
    let openedUrl = ActorIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
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
  
  @MainActor
  func test_didSaveUserSettings_onRideEventSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let testQueue = DispatchQueue.immediate

    let testClock = TestClock()
    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(
          rideEventSettings: .init(eventDistance: .close)
        )
      ),
      reducer: { SettingsFeature() },
      withDependencies: {
        $0.continuousClock = testClock
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.fileClient.save = { @Sendable _, _ in
          await didSaveUserSettings.setValue(true)
        }
        $0.observationModeStore.setObservationModeState = { _ in }
      }
    )
    
    // act
    await store.send(.rideevent(.set(\.$eventSearchRadius, .far))) {
      $0.rideEventSettings.eventSearchRadius = .far
    }

    await testClock.advance(by: .seconds(2))
    // assert
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
  }
  
  @MainActor
  func test_didSaveUserSettings_onAppearanceSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)

    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(
          appearanceSettings: .init(
            appIcon: .appIcon1,
            colorScheme: .light
          )
        )
      ),
      reducer: { SettingsFeature() }
    )
    let testClock = TestClock()
    store.dependencies.continuousClock = testClock
    store.dependencies.mainQueue = .immediate
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    store.dependencies.observationModeStore.setObservationModeState = { _ in }
    
    // act
    await store.send(.appearance(.set(\.$colorScheme, .dark))) {
      $0.appearanceSettings.colorScheme = .dark
    }

    await testClock.advance(by: .seconds(2))
    // assert
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
    await store.finish()
  }
  
  @MainActor
  func test_didSaveUserSettings_onSettingsChange() async throws {
    let didSaveUserSettings = ActorIsolated(false)
    let testQueue = DispatchQueue.immediate

    let store = TestStore(
      initialState: SettingsFeature.State(
        userSettings: .init(enableObservationMode: false)
      ),
      reducer: { SettingsFeature() }
    )
    store.dependencies.mainQueue = testQueue.eraseToAnyScheduler()
    store.dependencies.fileClient.save = { @Sendable _, _ in
      await didSaveUserSettings.setValue(true)
    }
    let testClock = TestClock()
    store.dependencies.continuousClock = testClock
    store.dependencies.observationModeStore.setObservationModeState = { _ in }
    
    // act
    await store.send(.set(\.$isObservationModeEnabled, true)) {
      $0.isObservationModeEnabled = true
    }

    // assert
    await testClock.advance(by: .seconds(2))
    await didSaveUserSettings.withValue { val in
      XCTAssertTrue(val, "Expected that save is invoked")
    }
  }
}
