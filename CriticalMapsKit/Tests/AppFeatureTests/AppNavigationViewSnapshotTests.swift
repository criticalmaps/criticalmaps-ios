import Foundation
import TestHelper
import XCTest
import AppFeature

class AppNavigationViewSnapshotTests: XCTestCase {
  func test_appNavigationView_light() {
    let sut = AppNavigationView(
      store: .init(
        initialState: .init(
          locationsAndChatMessages: nil),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .unimplemented(),
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    
    assertScreenSnapshot(sut, sloppy: true)
  }
  
  func test_appNavigationView_dark() {
    let sut = AppNavigationView(
      store: .init(
        initialState: .init(
          locationsAndChatMessages: nil),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          locationManager: .unimplemented(),
          nextRideService: .noop,
          userDefaultsClient: .noop,
          date: Date.init,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    .environment(\.colorScheme, .dark)
    
    assertScreenSnapshot(sut, sloppy: true)
  }
}
