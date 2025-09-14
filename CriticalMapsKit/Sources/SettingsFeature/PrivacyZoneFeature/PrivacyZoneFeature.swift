import ComposableArchitecture
import MapKit
import SharedModels
import SwiftUI
import CoreLocation

@Reducer
public struct PrivacyZoneFeature {
  public init() {}
  
  @Reducer
  public enum Destination {
    case createZoneSheet(CreateZoneFeature)
    case confirmationDialog
  }
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.privacyZoneSettings) var settings
    
    @Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    @Presents var destination: Destination.State?
    
    // UI State
    public var selectedZone: PrivacyZone?
    var zoneDeletionCandidate: PrivacyZone?
    
    var shouldPresentDisabledView: Bool {
      !settings.isEnabled && settings.zones.isEmpty
    }
    
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
    
    // UI
    case dismissConfirmationDialog
    
    @CasePathable
    public enum ConfirmationDialog: Equatable {
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
        
        state.confirmationDialog = .deletePrivacyZone(zone: zone)
        return .none
        
      case let .toggleZoneActive(zone):
        state.$settings.withLock { settings in
          settings.toggleZone(withID: zone.id)
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
          settings.shouldShowZonesOnMap.toggle()
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

extension PrivacyZoneFeature.Destination.State: Equatable {}

extension PrivacyZoneFeature.State {
  subscript(isActiveID id: UUID) -> Bool {
    get { settings.zones[id: id]?.isActive ?? false }
    set { $settings.withLock { $0.zones[id: id]?.isActive = newValue } }
  }
}

extension ConfirmationDialogState where Action == PrivacyZoneFeature.Action.ConfirmationDialog {
  public static func deletePrivacyZone(zone: PrivacyZone) -> Self {
    ConfirmationDialogState {
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
  }
}
