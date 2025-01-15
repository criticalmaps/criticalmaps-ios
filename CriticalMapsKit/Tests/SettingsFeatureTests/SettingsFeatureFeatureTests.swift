import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import Testing

@Suite
@MainActor
struct SettingsFeatureCoreTests {
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_privacy() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.privacy

    await store.send(.infoSectionRowTapped(row))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_cmWebsite() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.website

    await store.send(.infoSectionRowTapped(row))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_cmMastodon() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.InfoSectionRow.mastodon

    await store.send(.infoSectionRowTapped(row))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_github() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.github

    await store.send(.supportSectionRowTapped(row))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_crowdin() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.crowdin

    await store.send(.supportSectionRowTapped(row))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func openURLAction_shouldCallUIApplicationClient_criticalMassDotIn() async {
    let openedUrl = LockIsolated<URL?>(nil)
    
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() }
    )
    store.dependencies.uiApplicationClient.open = { url, _ in
      openedUrl.setValue(url)
      return true
    }
    
    let row = SettingsFeature.State.SupportSectionRow.criticalMassDotIn

    await store.send(.supportSectionRowTapped(row))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
//  @MainActor
//  func test_didSaveUserSettings_onRideEventSettingsChange() async throws {
//    let didSaveUserSettings = LockIsolated(false)
//    let testQueue = DispatchQueue.immediate
//
//    let testClock = TestClock()
//    let store = TestStore(
//      initialState: SettingsFeature.State(),
//      reducer: { SettingsFeature() },
//      withDependencies: {
//        $0.continuousClock = testClock
//        $0.mainQueue = testQueue.eraseToAnyScheduler()
//        $0.fileClient.save = { @Sendable _, _ in
//          didSaveUserSettings.setValue(true)
//        }
//        $0.feedbackGenerator.selectionChanged = {}
//      }
//    )
//    
//    // act
//    await store.send(.rideevent(.binding(.set(\.eventSearchRadius, .far))) {
//      $0.rideEventSettings.eventSearchRadius = .far
//    }
//
//    await testClock.advance(by: .seconds(2))
//    // assert
//    didSaveUserSettings.withValue { val in
//      XCTAssertTrue(val, "Expected that save is invoked")
//    }
//  }
  
//  @MainActor
//  func test_didSaveUserSettings_onAppearanceSettingsChange() async throws {
//    let didSaveUserSettings = LockIsolated(false)
//
//    let store = TestStore(
//      initialState: SettingsFeature.State(
//        userSettings: .init(
//          appearanceSettings: .init(
//            appIcon: .appIcon1,
//            colorScheme: .light
//          )
//        )
//      ),
//      reducer: { SettingsFeature() }
//    )
//    let testClock = TestClock()
//    store.dependencies.continuousClock = testClock
//    store.dependencies.mainQueue = .immediate
//    store.dependencies.fileClient.save = { @Sendable _, _ in
//      didSaveUserSettings.setValue(true)
//    }
//    
//    // act
//    await store.send(.appearance(.set(\.$colorScheme, .dark))) {
//      $0.appearanceSettings.colorScheme = .dark
//    }
//
//    await testClock.advance(by: .seconds(2))
//    // assert
//    didSaveUserSettings.withValue { val in
//      XCTAssertTrue(val, "Expected that save is invoked")
//    }
//    await store.finish()
//  }
  
  @Test
  func didSaveUserSettings_onSettingsChange() async throws {
    @Shared(.userSettings)
    var userSettings = UserSettings(enableObservationMode: false)
    
    let didCallStopLocationUpdates = LockIsolated(false)
    let testQueue = DispatchQueue.immediate

    let testClock = TestClock()
    let store = TestStore(
      initialState: SettingsFeature.State(),
      reducer: { SettingsFeature() },
      withDependencies: {
        $0.mainQueue = testQueue.eraseToAnyScheduler()
        $0.locationManager.stopUpdatingLocation = {
          didCallStopLocationUpdates.setValue(true)
        }
        $0.continuousClock = testClock
      }
    )

    
    // act
    await store.send(.binding(.set(\.userSettings.isObservationModeEnabled, true))) {
      $0.$userSettings.withLock { $0.isObservationModeEnabled = true }
    }

    // assert
    await testClock.advance(by: .seconds(2))
    didCallStopLocationUpdates.withValue { val in
      #expect(val == true, "Expected that save is invoked")
    }
  }
}
