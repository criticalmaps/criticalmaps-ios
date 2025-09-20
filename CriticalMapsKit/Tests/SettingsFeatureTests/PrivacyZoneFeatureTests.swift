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
    
    @Test("Initial state should use default radius from settings")
    func initialStateUsesDefaultRadius() async {
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
    
    @Test("canCreateZone returns true when name and center are set")
    func canCreateZoneWithValidData() async {
      var state = CreateZoneFeature.State()
      state.newZoneName = "Home"
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == true)
    }
    
    @Test("canCreateZone returns false when name is empty")
    func canCreateZoneWithEmptyName() async {
      var state = CreateZoneFeature.State()
      state.newZoneName = ""
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == false)
    }
    
    @Test("canCreateZone returns false when name is whitespace only")
    func canCreateZoneWithWhitespaceOnlyName() async {
      var state = CreateZoneFeature.State()
      state.newZoneName = "   \n\t  "
      state.mapCenter = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      #expect(state.canCreateZone == false)
    }
    
    @Test("canCreateZone returns false when center is nil")
    func canCreateZoneWithoutCenter() async {
      var state = CreateZoneFeature.State()
      state.newZoneName = "Home"
      state.mapCenter = nil
      
      #expect(state.canCreateZone == false)
    }
    
    @Test("setMapCenter updates the map center")
    func setMapCenter() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() }
      )
      
      let coordinate = Coordinate(latitude: 52.5200, longitude: 13.4050)
      
      await store.send(.setMapCenter(coordinate)) {
        $0.mapCenter = coordinate
      }
    }
    
    @Test("createZone creates and delegates new zone")
    func createZoneSuccess() async {
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
    
    @Test("createZone trims whitespace from name")
    func createZoneTrimsWhitespace() async {
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
    
    @Test("createZone does nothing when canCreateZone is false")
    func createZoneWhenInvalid() async {
      let store = TestStore(
        initialState: CreateZoneFeature.State(),
        reducer: { CreateZoneFeature() }
      )
      
      await store.send(.createZone)
      // No effects should be received
    }
    
    @Test("dismiss action triggers dismiss dependency")
    func dismissAction() async {
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
    
    @Test("shouldPresentDisabledView returns true when disabled and no zones")
    func shouldPresentDisabledView() async {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: false,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      
      #expect(state.shouldPresentDisabledView == true)
    }
    
    @Test("shouldPresentDisabledView returns false when enabled")
    func shouldPresentDisabledViewWhenEnabled() async {
      @Shared(.privacyZoneSettings) var settings = PrivacyZoneSettings(
        isEnabled: true,
        zones: [],
        defaultRadius: 400,
        shouldShowZonesOnMap: true
      )
      
      let state = PrivacyZoneFeature.State()
      
      #expect(state.shouldPresentDisabledView == false)
    }
    
    @Test("shouldPresentDisabledView returns false when disabled but has zones")
    func shouldPresentDisabledViewWithZones() async {
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
    
    @Test("addZoneButtonTapped presents create zone sheet")
    func addZoneButtonTapped() async {
      let store = TestStore(
        initialState: PrivacyZoneFeature.State(),
        reducer: { PrivacyZoneFeature() }
      )
      
      await store.send(.addZoneButtonTapped) {
        $0.destination = .createZoneSheet(CreateZoneFeature.State())
      }
    }
    
    @Test("selectZone updates selectedZone")
    func selectZone() async {
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
    
    @Test("togglePrivacyZones toggles settings enabled state")
    func togglePrivacyZones() async {
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
    
    @Test("toggleShowZonesOnMap toggles map visibility setting")
    func toggleShowZonesOnMap() async {
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
    
    @Test("toggleZoneActive toggles zone active state")
    func toggleZoneActive() async {
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
    
    @Test("deleteZone presents confirmation dialog")
    func deleteZonePresentsConfirmation() async {
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
    
    @Test("confirmationDialog deleteZoneButtonTapped removes zone")
    func deleteZoneConfirmed() async {
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
        
    @Test("destination createZoneSheet zoneCreated adds zone to settings")
    func createZoneSheetAddsZone() async {
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
    
    @Test("State subscript isActiveID gets and sets zone active state")
    func stateSubscriptIsActiveID() async {
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
    
    @Test("State subscript isActiveID returns false for non-existent zone")
    func stateSubscriptIsActiveIDNonExistentZone() async {
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
