import ComposableArchitecture
import CoreLocation
import L10n
import MapKit
import SharedModels
import Styleguide
import SwiftUI

@Reducer
public struct PrivacyZoneFeature: Sendable {
  public init() {}
  
  @Reducer
  public enum Destination {
    case createZoneSheet(CreateZoneFeature)
    case confirmationDialog
  }
  
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared(.privacyZoneSettings) var settings
    
    @Presents var alert: AlertState<Action.Alert>?
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
    case alert(PresentationAction<Alert>)
    case destination(PresentationAction<Destination.Action>)
    
    // Zone Management
    case addZoneButtonTapped
    case deleteZone(PrivacyZone)
    case toggleZoneActive(PrivacyZone)
    case selectZone(PrivacyZone?)
    
    // Settings
    case togglePrivacyZones
    case toggleShowZonesOnMap
        
    @CasePathable
    public enum Alert: Equatable, Sendable {
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
        
        state.alert = .deletePrivacyZone(zone: zone)
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

      case .alert(.presented(.deleteZoneButtonTapped)):
        guard let deleteCandidate = state.zoneDeletionCandidate else {
          return .none
        }
        state.$settings.withLock { settings in
          settings.zones.remove(id: deleteCandidate.id)
        }
        state.zoneDeletionCandidate = nil
        state.alert = nil
        return .none
      
      case .alert:
        return .none
        
      case let .destination(.presented(.createZoneSheet(.delegate(.zoneCreated(zone))))):
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
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.$destination, action: \.destination)
  }
}

extension PrivacyZoneFeature.Destination.State: Equatable, Sendable {}

extension PrivacyZoneFeature.State {
  subscript(isActiveID id: UUID) -> Bool {
    get { settings.zones[id: id]?.isActive ?? false }
    set { $settings.withLock { $0.zones[id: id]?.isActive = newValue } }
  }
}

public extension AlertState where Action == PrivacyZoneFeature.Action.Alert {
  static func deletePrivacyZone(zone: PrivacyZone) -> Self {
    AlertState {
      TextState(L10n.PrivacyZone.Settings.Dialog.Delete.headline)
    } actions: {
      ButtonState(role: .cancel) {
        TextState(L10n.PrivacyZone.Settings.Dialog.Cta.cancel)
      }
      ButtonState(action: .deleteZoneButtonTapped) {
        TextState(L10n.PrivacyZone.Settings.Dialog.Cta.delete)
      }
    } message: {
      TextState(L10n.PrivacyZone.Settings.Dialog.message(zone.name))
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
    .navigationTitle(L10n.PrivacyZone.Settings.navigationTitle)
    .navigationBarTitleDisplayMode(.inline)
    .alert($store.scope(state: \.alert, action: \.alert))
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
        .tint(.primary)
        .disabled(!store.settings.isEnabled)
      }
    }
  }

  @ViewBuilder
  private var settingsSection: some View {
    SettingsForm {
      Section {
        Toggle(
          L10n.PrivacyZone.Settings.Toggle.enableFeature,
          isOn: $store.settings.isEnabled
        )
        .font(.body)
        
        Toggle(
          L10n.PrivacyZone.Settings.Toggle.showZonesOnMap,
          isOn: $store.settings.shouldShowZonesOnMap
        )
        .font(.body)
        .disabled(!store.settings.isEnabled)
      } header: {
        SectionHeader {
          Text(L10n.Settings.title)
        }
      } footer: {
        Text(L10n.PrivacyZone.Settings.Section.footer)
          .font(.footnote)
          .foregroundStyle(Color.textSecondary)
      }
      
      if !store.settings.zones.isEmpty {
        Section {
          ForEach(store.settings.zones, id: \.id) { zone in
            ZoneRow(
              zone: zone,
              isActive: $store.state[isActiveID: zone.id],
              onDelete: { store.send(.deleteZone(zone)) }
            )
          }
          .disabled(!store.settings.isEnabled)
        } header: {
          SectionHeader {
            Text(L10n.PrivacyZone.Settings.Section.yourZones)
          }
        }
      } else {
        Section {
          VStack(spacing: .grid(3)) {
            Asset.pzLocationShield.swiftUIImage
              .font(.title2)
            
            Text(L10n.PrivacyZone.Settings.Empty.headline)
              .font(.subheadline)
            
            Text(L10n.PrivacyZone.Settings.Empty.subheadline)
              .font(.caption)
              .multilineTextAlignment(.center)
          }
          .foregroundColor(.textSecondary)
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
