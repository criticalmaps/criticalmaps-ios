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
