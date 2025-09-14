import ComposableArchitecture
import CoreLocation
import MapKit
import SharedModels
import Styleguide
import SwiftUI

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


// MARK: - View

public struct PrivacyZoneSettingsView: View {
  @Bindable var store: StoreOf<PrivacyZoneFeature>
  
  public init(store: StoreOf<PrivacyZoneFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      if store.shouldPresentDisabledView {
        PrivacyZoneDisabledView {
          store.send(.togglePrivacyZones)
        }
      } else {
        settingsSection
      }
    }
    .navigationTitle("Privacy Zone Settings")
    .navigationBarTitleDisplayMode(.inline)
    .confirmationDialog(
      $store.scope(
        state: \.confirmationDialog,
        action: \.confirmationDialog
      )
    )
    .sheet(
      item: $store.scope(
        state: \.destination?.createZoneSheet,
        action: \.destination.createZoneSheet
      )
    ) { createZoneStore in
      CreatePrivacyZoneView(store: createZoneStore)
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Add", systemImage: "plus") {
          store.send(.addZoneButtonTapped)
        }
        .labelStyle(.iconOnly)
        .disabled(!store.settings.isEnabled)
      }
    }
  }

  
  @ViewBuilder
  private var settingsSection: some View {
    SettingsForm {
      Section {
        Toggle(
          "Enable Privacy Zones",
          isOn: $store.settings.isEnabled
        )
        .font(.body)
        
        Toggle(
          "Show Zones on Map",
          isOn: $store.settings.shouldShowZonesOnMap
        )
        .font(.body)
      } header: {
        SectionHeader {
          Text("Settings")
        }
      } footer: {
        Text("Privacy zones prevent your location from being shared when you're within the defined area.")
          .font(.footnote)
      }
      
      if !store.settings.zones.isEmpty {
        Section {
          ForEach(store.settings.zones) { zone in
            ZoneRow(
              zone: zone,
              isActive: $store.state[isActiveID: zone.id],
              onDelete: { store.send(.deleteZone(zone)) }
            )
          }
        } header: {
          SectionHeader {
            Text("Your Privacy Zones (\(store.settings.zones.count))")
          }
        }
      } else {
        Section {
          VStack(spacing: .grid(3)) {
            Asset.pzLocationShield.swiftUIImage
              .font(.title2)
              .foregroundColor(.secondary)
            
            Text("No privacy zones created yet")
              .font(.subheadline)
              .foregroundColor(.secondary)
            
            Text("Create your first zone to start protecting your privacy")
              .font(.caption)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    PrivacyZoneSettingsView(
      store: Store(initialState: PrivacyZoneFeature.State()) {
        PrivacyZoneFeature()
      }
    )
  }
}

struct SymbolTransitionModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 18.0, *) {
      content
        .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
    } else {
      content
        .contentTransition(.symbolEffect(.replace))
    }
  }
}

extension View {
  func symbolTransition() -> some View {
    modifier(SymbolTransitionModifier())
  }
}
