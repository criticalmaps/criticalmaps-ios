import ComposableArchitecture
import Foundation
@testable import SettingsFeature
import SharedModels
import Testing

@Suite("PrivacyZoneFeature Tests")
@MainActor
struct Settings_PrivacyZoneFeatureTests {
  let testDate = Date(timeIntervalSinceReferenceDate: 0)
  let testUUID = UUID(0)
  
  // MARK: - CreateZoneFeature Tests
  
  @MainActor
  @Suite("CreateZoneFeature")
  struct CreateZoneFeatureTests {
    let testDate = Date(timeIntervalSinceReferenceDate: 0)
    let testUUID = UUID(0)
    
    @Test
    func `Initial state should use default radius from settings`() {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 500,
        shouldShowZonesOnMap: true
      )
      
      let state = CreateZoneFeature.State()
      
      #expect(state.newZoneRadius == 500)
      #expect(state.newZoneName == "")
      #expect(state.mapCenter == nil)
      #expect(state.canCreateZone == false)
    }
    
    @Test
    func `canCreateZone returns true when name and center are set`() {
      var state = CreateZoneFeature.State()
      state.newZoneName = "Home"
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == true)
    }
    
    @Test
    func `canCreateZone returns false when name is empty`() {
      var state = CreateZoneFeature.State()
      state.newZoneName = ""
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == false)
    }
    
    @Test
    func `canCreateZone returns false when name is whitespace only`() {
      var state = CreateZoneFeature.State()
      state.newZoneName = "   \n\t  "
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == false)
    }
    
    @Test
    func `canCreateZone returns false when center is nil`() {
      var state = CreateZoneFeature.State()
      state.newZoneName = "Home"
      state.mapCenter = nil
      
      #expect(state.canCreateZone == false)
    }
    
    @Test
    func `setMapCenter updates the map center`() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() }
      )
      
      let coordinate = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      await store.send(.setMapCenter(coordinate)) {
        $0.mapCenter = coordinate
      }
    }
    
    @Test
    func `createZone creates and delegates new zone`() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() },
        withDependencies: {
          $0.uuid = .constant(testUUID)
          $0.date = .constant(testDate)
        }
      )
      
      let coordinate = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      await store.send(.binding(.set(\.newZoneName, "Home"))) {
        $0.newZoneName = "Home"
      }
      
      await store.send(.binding(.set(\.newZoneRadius, 300))) {
        $0.newZoneRadius = 300
      }
      
      await store.send(.setMapCenter(coordinate)) {
        $0.mapCenter = coordinate
      }
      
      await store.send(.createZone)
      
      await store.receive(\.delegate.zoneCreated)
    }
    
    @Test
    func `createZone trims whitespace from name`() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() },
        withDependencies: {
          $0.uuid = .constant(testUUID)
          $0.date = .constant(testDate)
        }
      )
      
      let coordinate = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      await store.send(.binding(.set(\.newZoneName, "  Home  \n"))) {
        $0.newZoneName = "  Home  \n"
      }
      
      await store.send(.setMapCenter(coordinate)) {
        $0.mapCenter = coordinate
      }
      
      await store.send(.createZone)
      
      await store.receive(\.delegate.zoneCreated)
    }
    
    @Test
    func `createZone does nothing when canCreateZone is false`() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() }
      )
      
      await store.send(.createZone)
      // No effects should be received
    }
    
    @Test
    func `dismiss action triggers dismiss dependency`() async {
      let dismissCalled = LockIsolated(false)
      
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() },
        withDependencies: {
          $0.dismiss = DismissEffect {
            dismissCalled.setValue(true)
          }
        }
      )
      
      await store.send(.dismiss)
      
      #expect(dismissCalled.value == true)
    }
  }
  
  // MARK: - PrivacyZoneFeature Tests
  
  @Suite("PrivacyZoneFeature")
  @MainActor
  struct PrivacyZoneFeatureTests {
    let testDate = Date(timeIntervalSinceReferenceDate: 0)
    
    @Test
    func `shouldPresentDisabledView returns true when disabled and no zones`() {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: false,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      
      #expect(state.shouldPresentDisabledView == true)
    }
    
    @Test
    func `shouldPresentDisabledView returns false when enabled`() {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      
      #expect(state.shouldPresentDisabledView == false)
    }
    
    @Test
    func `shouldPresentDisabledView returns false when disabled but has zones`() {
      let zone = PrivacyZone(
        id: UUID(),
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400
      )
      
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: false,
        zones: [zone],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      
      #expect(state.shouldPresentDisabledView == false)
    }
    
    @Test
    func `addZoneButtonTapped presents create zone sheet`() async {
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.addZoneButtonTapped) {
        $0.destination = .createZoneSheet(CreateZoneFeature.State())
      }
    }
    
    @Test
    func `selectZone updates selectedZone`() async {
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      let zone = PrivacyZone(
        id: UUID(),
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400
      )
      
      await store.send(.selectZone(zone)) {
        $0.selectedZone = zone
      }
      
      await store.send(.selectZone(nil)) {
        $0.selectedZone = nil
      }
    }
    
    @Test
    func `togglePrivacyZones toggles settings enabled state`() async {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: false,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.togglePrivacyZones) { state in
        state.$settings.withLock { $0.isEnabled = true }
      }
      await store.send(.togglePrivacyZones) { state in
        state.$settings.withLock { $0.isEnabled = false }
      }
    }
    
    @Test
    func `toggleShowZonesOnMap toggles map visibility setting`() async {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.toggleShowZonesOnMap) { state in
        state.$settings.withLock { $0.shouldShowZonesOnMap = false }
      }
            
      await store.send(.toggleShowZonesOnMap) { state in
        state.$settings.withLock { $0.shouldShowZonesOnMap = true }
      }
    }
    
    @Test
    func `toggleZoneActive toggles zone active state`() async {
      let zoneId = UUID()
      let zone = PrivacyZone(
        id: zoneId,
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400,
        isActive: true
      )
      
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [zone],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.toggleZoneActive(zone)) { state in
        state.$settings.withLock { $0.zones[id: zoneId]?.isActive = false }
      }
      await store.send(.toggleZoneActive(zone)) { state in
        state.$settings.withLock { $0.zones[id: zoneId]?.isActive = true }
      }
    }
    
    @Test
    func `deleteZone presents confirmation dialog`() async {
      let zone = PrivacyZone(
        id: UUID(),
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400
      )
      
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.deleteZone(zone)) {
        $0.zoneDeletionCandidate = zone
        $0.alert = .deletePrivacyZone(zone: zone)
      }
    }
    
    @Test
    func `confirmationDialog deleteZoneButtonTapped removes zone`() async {
      let zoneId = UUID()
      let zone = PrivacyZone(
        id: zoneId,
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400
      )
      let otherZone = PrivacyZone(
        id: UUID(),
        name: "Work",
        center: Coordinate(latitude: 52.5100, longitude: 13.4000),
        radius: 300
      )
      
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [zone, otherZone],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      var state = PrivacyZoneFeature.State()
      state.zoneDeletionCandidate = zone
      
      let store = TestStore(
        initialState: state,
        reducer: { PrivacyZoneFeature() }
      )
      await store.send(.deleteZone(zone)) {
        $0.alert = .deletePrivacyZone(zone: zone)
      }
      await store.send(.alert(.presented(.deleteZoneButtonTapped))) { state in
        state.zoneDeletionCandidate = nil
        state.alert = nil
        state.$settings.withLock { $0.zones = [otherZone] }
      }
      
      #expect(settings.zones.count == 1)
      #expect(settings.zones[id: zoneId] == nil)
      #expect(settings.zones.first?.name == "Work")
    }
        
    @Test
    func `destination createZoneSheet zoneCreated adds zone to settings`() async {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      let newZone = PrivacyZone(
        id: UUID(),
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400
      )
      
      await store.send(.addZoneButtonTapped) {
        $0.destination = .createZoneSheet(CreateZoneFeature.State())
      }
      await store.send(.destination(.presented(.createZoneSheet(.delegate(.zoneCreated(newZone)))))) { state in
        state.$settings.withLock { $0.zones = [newZone] }
      }
      
      #expect(settings.zones.count == 1)
      #expect(settings.zones.first == newZone)
    }
    
    @Test
    func `State subscript isActiveID gets and sets zone active state`() {
      let zoneId = UUID()
      let zone = PrivacyZone(
        id: zoneId,
        name: "Home",
        center: Coordinate(latitude: 52.5200, longitude: 13.4050),
        radius: 400,
        isActive: true
      )
      
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [zone],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      var state = PrivacyZoneFeature.State()
      
      #expect(state[isActiveID: zoneId] == true)
      
      state[isActiveID: zoneId] = false
      
      #expect(settings.zones[id: zoneId]?.isActive == false)
      #expect(state[isActiveID: zoneId] == false)
    }
    
    @Test
    func `State subscript isActiveID returns false for non-existent zone`() {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      let nonExistentId = UUID()
      
      #expect(state[isActiveID: nonExistentId] == false)
    }
  }
}

// MARK: - Test Helpers

extension UUID {
  init(_ value: Int) {
    let bytes: [UInt8] = [
      UInt8((value >> 8) & 0xFF),
      UInt8(value & 0xFF),
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
    let uuid = NSUUID(uuidBytes: bytes)
    self = uuid as UUID
  }
}
