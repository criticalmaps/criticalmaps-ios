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
    
    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
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
    
    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
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

    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
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

    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
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
    
    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
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

    await openedUrl.withValue({ url in
      XCTAssertEqual(url, row.url)
    })
  }
}
