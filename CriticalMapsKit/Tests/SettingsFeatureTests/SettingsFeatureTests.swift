import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import Testing

@MainActor
struct SettingsFeatureCoreTests {
  @Test
  func `open URL action should call UI application client privacy`() async {
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

    await store.send(.view(.infoSectionRowTapped(row)))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `open URL action should call UI application client cm website`() async {
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

    await store.send(.view(.infoSectionRowTapped(row)))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `open URL action should call UI application client cm mastodon`() async {
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

    await store.send(.view(.infoSectionRowTapped(row)))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `open URL action should call UI application client github`() async {
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

    await store.send(.view(.supportSectionRowTapped(row)))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `open URL action should call UI application client crowdin`() async {
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

    await store.send(.view(.supportSectionRowTapped(row)))
    await store.receive(\.openURL)
    
    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `open URL action should call UI application client critical mass dot in`() async {
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

    await store.send(.view(.supportSectionRowTapped(row)))
    await store.receive(\.openURL)

    openedUrl.withValue { url in
      #expect(url == row.url)
    }
  }
  
  @Test
  func `did save user settings on settings change`() async {
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
    await store.send(.view(.observationModeChanged(true)))

    // assert
    await testClock.advance(by: .seconds(2))
    didCallStopLocationUpdates.withValue { val in
      #expect(val == true, "Expected that save is invoked")
    }
  }
}
