import ComposableArchitecture
import Foundation
import IDProvider
import Testing

@Suite
struct IDProviderTests {
  let deviceID = "00000000-0000-0000-0000-000000000001"
  
  @Test("ID changes when device ID changes")
  func IDDoesChange() {
    let date = Date(timeIntervalSince1970: 1557057968)
    let currentID = withDependencies { values in
      values.date = DateGenerator { date }
      values.userDefaultsClient.stringForKey = { _ in deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(7200)
    let newID = withDependencies { values in
      values.date = DateGenerator { newDate }
      values.userDefaultsClient.stringForKey = { _ in deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    #expect(currentID.id() == newID.id())
  }
  
  @Test("ID does not change when device ID does not change")
  func IDDoesNotChange() {
    let date = Date(timeIntervalSince1970: 1557057968)
    let currentID = withDependencies { values in
      values.date = DateGenerator { date }
      values.userDefaultsClient.stringForKey = { _ in deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(86400)
    let newID = withDependencies { values in
      values.date = DateGenerator { newDate }
      values.userDefaultsClient.stringForKey = { _ in deviceID }
    } operation: {
      IDProvider.liveValue
    }
    
    #expect(currentID.id() != newID.id())
  }
}
