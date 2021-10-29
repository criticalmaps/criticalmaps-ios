import Foundation
import TestHelper
import XCTest
import AppFeature
import SnapshotTesting

class AppNavigationViewSnapshotTests: XCTestCase {
  func test_appNavigationView_light() {
    let view = AppNavigationView(
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
    
    assertSnapshots(
      matching: view,
      as: [
        .image(precision: 0.9, layout: .device(config: .iPhoneX))
      ],
      file: #file,
      testName: #function,
      line: #line
    )
  }
  
  func test_appNavigationView_dark() {
    let view = AppNavigationView(
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
    
    assertScreenSnapshot(view, sloppy: true)
  }
}
