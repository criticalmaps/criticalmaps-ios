import ComposableArchitecture
import MapKit
import SharedModels
import SwiftUI
import CoreLocation

@Reducer
public struct CreateZoneFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.privacyZoneSettings) var settings
    public var newZoneName = ""
    public var newZoneRadius: Double = 400
    public var mapCenter: Coordinate?
    
    public init() {
      // Initialize radius with default from settings
      self.newZoneRadius = settings.defaultRadius
    }
    
    public var canCreateZone: Bool {
      !newZoneName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
      mapCenter != nil
    }
  }
  
  @CasePathable
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case createZone
    case setMapCenter(Coordinate?)
    case dismiss
    case delegate(Delegate)
    
    @CasePathable
    public enum Delegate {
      case zoneCreated(PrivacyZone)
    }
  }
  
  @Dependency(\.uuid) var uuid
  @Dependency(\.date) var date
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .createZone:
        guard
          state.canCreateZone,
          let center = state.mapCenter
        else {
          return .none
        }
        
        let newZone = PrivacyZone(
          id: uuid(),
          name: state.newZoneName.trimmingCharacters(in: .whitespacesAndNewlines),
          center: center,
          radius: state.newZoneRadius,
          createdAt: date()
        )
        
        return .run { send in
          await send(.delegate(.zoneCreated(newZone)))
          await dismiss()
        }
        
      case let .setMapCenter(coordinate):
        state.mapCenter = coordinate
        return .none
        
      case .dismiss:
        return .run { _ in
          await dismiss()
        }
        
      case .delegate:
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}

@Reducer
public struct PrivacyZoneFeature {
  public init() {}
  
  @Reducer
  public enum Destination {
    case createZoneSheet(CreateZoneFeature)
  }
  
  @ObservableState
  public struct State {
    @Shared(.privacyZoneSettings) var settings
    
    @Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    @Presents var destination: Destination.State?
    
    // UI State
    public var selectedZone: PrivacyZone?
    var zoneDeletionCandidate: PrivacyZone?
    
    public init() {}
  }
  
  @CasePathable
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case confirmationDialog(PresentationAction<ConfirmationDialog>)
    case destination(PresentationAction<Destination.Action>)
    
    // Zone Management
    case addZoneButtonTapped
    case deleteZone(PrivacyZone)
    case toggleZoneActive(PrivacyZone)
    case selectZone(PrivacyZone?)
    
    // Settings
    case togglePrivacyZones
    case toggleShowZonesOnMap
    case setDefaultRadius(Double)
    
    // UI
    case dismissConfirmationDialog
    
    @CasePathable
    public enum ConfirmationDialog {
      case deleteZoneButtonTapped
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .addZoneButtonTapped:
        state.destination = .createZoneSheet(CreateZoneFeature.State())
        return .none
        
      case let .deleteZone(zone):
        state.zoneDeletionCandidate = zone
        
        state.confirmationDialog = ConfirmationDialogState {
          TextState("Delete Privacy Zone")
        } actions: {
          ButtonState(role: .cancel) {
            TextState("Cancel")
          }
          ButtonState(action: .deleteZoneButtonTapped) {
            TextState("Delete Zone")
          }
        } message: {
          TextState("Are you sure you want to delete the privacy zone '\(zone.name)'? This action cannot be undone.")
        }
        return .none
        
      case let .toggleZoneActive(zone):
        state.$settings.withLock { settings in
          if let index = settings.zones.firstIndex(where: { $0.id == zone.id }) {
            settings.zones[index] = PrivacyZone(
              id: zone.id,
              name: zone.name,
              center: zone.center,
              radius: zone.radius,
              isActive: !zone.isActive,
              createdAt: zone.createdAt
            )
          }
        }
        return .none
        
      case let .selectZone(zone):
        state.selectedZone = zone
        return .none
        
      case .togglePrivacyZones:
        state.$settings.withLock { settings in
          settings.isEnabled.toggle()
        }
        return .none
        
      case .toggleShowZonesOnMap:
        state.$settings.withLock { settings in
          settings.showZonesOnMap.toggle()
        }
        return .none
        
      case let .setDefaultRadius(radius):
        state.$settings.withLock { settings in
          settings.defaultRadius = radius
        }
        return .none
        
      case .dismissConfirmationDialog:
        state.confirmationDialog = nil
        return .none
        
      case .confirmationDialog(.presented(.deleteZoneButtonTapped)):
        guard let deleteCandidate = state.zoneDeletionCandidate else {
          return .none
        }
        state.$settings.withLock { settings in
          settings.zones.removeAll { $0.id == deleteCandidate.id }
        }
        state.zoneDeletionCandidate = nil
        state.confirmationDialog = nil
        return .none
      
      case .confirmationDialog:
        return .none
        
      case .destination(.presented(.createZoneSheet(.delegate(.zoneCreated(let zone))))):
        state.$settings.withLock { settings in
          settings.zones.append(zone)
        }
        return .none
        
      case .destination:
        return .none
      
      case .binding:
        return .none
      }
    }
    .ifLet(\.$confirmationDialog, action: \.confirmationDialog)
    .ifLet(\.$destination, action: \.destination)
  }
}
