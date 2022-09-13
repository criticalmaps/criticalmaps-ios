import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class RideEventSettingsCoreTests: XCTestCase {
  
  func test_setRideEventsEnabled() {
    let store = TestStore(
      initialState: RideEventSettings(
        isEnabled: true,
        typeSettings: .all,
        eventDistance: .close
      ),
      reducer: RideEventsSettingsFeature()
    )
    
    store.send(.setRideEventsEnabled(false)) {
      $0.isEnabled = false
    }
    
    store.send(.setRideEventsEnabled(true)) {
      $0.isEnabled = true
    }
  }
  
  func test_setRideEventsTypeEnabled() {
    let store = TestStore(
      initialState: RideEventSettings(
        isEnabled: true,
        typeSettings: .all,
        eventDistance: .close
      ),
      reducer: RideEventsSettingsFeature()
    )
    
    var updatedType = RideEventSettings.RideEventTypeSetting(type: .kidicalMass, isEnabled: false)
    store.send(.setRideEventTypeEnabled(updatedType)) {
      var updatedSettings: [RideEventSettings.RideEventTypeSetting] = .all
      let index = try XCTUnwrap(updatedSettings.firstIndex(where: { setting in
        setting.type == updatedType.type
      }))
      updatedSettings[index] = updatedType
      $0.typeSettings = updatedSettings
    }
    
    updatedType.isEnabled = true
    store.send(.setRideEventTypeEnabled(updatedType)) {
      $0.typeSettings = .all
    }
  }
  
  func test_setRideEventsRadius() {
    let store = TestStore(
      initialState: RideEventSettings(
        isEnabled: true,
        typeSettings: .all,
        eventDistance: .close
      ),
      reducer: RideEventsSettingsFeature()
    )
    
    store.send(.setRideEventRadius(.near)) {
      $0.eventDistance = .near
    }
  }
}
