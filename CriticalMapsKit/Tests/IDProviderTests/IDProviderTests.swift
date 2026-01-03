import ComposableArchitecture
import Foundation
import IDProvider
import SharedKeys
import Testing

@Suite
struct IDProviderTests {
  let deviceID = "00000000-0000-0000-0000-000000000001"
  
  @Test
  func `ID changes when device ID changes`() {
    let date = Date(timeIntervalSince1970: 1557057968)
    @Shared(.sessionID) var sessionID = deviceID
    
    let currentID = withDependencies { values in
      values.date = DateGenerator { date }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(7200)
    let newID = withDependencies { values in
      values.date = DateGenerator { newDate }
    } operation: {
      IDProvider.liveValue
    }
    
    #expect(currentID.id() == newID.id())
  }
  
  @Test("ID does not change when device ID does not change")
  func iDDoesNotChange() {
    let date = Date(timeIntervalSince1970: 1557057968)
    @Shared(.sessionID) var sessionID = deviceID
    let currentID = withDependencies { values in
      values.date = DateGenerator { date }
    } operation: {
      IDProvider.liveValue
    }
    
    let newDate = date.addingTimeInterval(86400)
    let newID = withDependencies { values in
      values.date = DateGenerator { newDate }
    } operation: {
      IDProvider.liveValue
    }
    
    #expect(currentID.id() != newID.id())
  }
}
