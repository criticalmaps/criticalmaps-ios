import ComposableArchitecture
import SharedModels
import SwiftUI

public struct PrivacyZoneSettingsView: View {
  @Bindable var store: StoreOf<PrivacyZoneFeature>
  
  public init(store: StoreOf<PrivacyZoneFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      if store.settings.isEnabled {
        settingsSection
      } else {
        disabledStateView
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
      CreateZoneView(store: createZoneStore)
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Add New Zone", systemImage: "plus") {
          store.send(.addZoneButtonTapped)
        }
        .labelStyle(.iconOnly)
        .disabled(!store.settings.isEnabled)
      }
    }
  }

  
  @ViewBuilder
  private var settingsSection: some View {
    List {
      Section {
        Toggle(
          "Enable Privacy Zones",
          isOn: $store.settings.isEnabled
        )
        .onChange(of: store.settings.isEnabled) {
          store.send(.togglePrivacyZones)
        }
        
        Toggle(
          "Show Zones on Map",
          isOn: $store.settings.showZonesOnMap
        )
        .onChange(of: store.settings.showZonesOnMap) {
          store.send(.toggleShowZonesOnMap)
        }
      } header: {
        Text("Settings")
      } footer: {
        Text("Privacy zones prevent your location from being shared when you're within the defined area.")
      }
      
      if !store.settings.zones.isEmpty {
        Section("Your Privacy Zones (\(store.settings.zones.count))") {
          ForEach(store.settings.zones) { zone in
            ZoneRow(
              zone: zone,
              onToggleActive: { store.send(.toggleZoneActive(zone)) },
              onDelete: { store.send(.deleteZone(zone)) }
            )
          }
        }
      } else {
        Section {
          VStack(spacing: 12) {
            Image(systemName: "location.circle")
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
          .padding(.vertical, 20)
        }
      }
    }
  }
  
  @ViewBuilder
  private var disabledStateView: some View {
    VStack(spacing: 24) {
      Spacer()
      
      VStack(spacing: 16) {
        Image(systemName: "location.slash.circle.fill")
          .font(.system(size: 60))
          .foregroundColor(.secondary)
        
        VStack(spacing: 8) {
          Text("Privacy Zones")
            .font(.title2)
            .fontWeight(.semibold)
          
          Text("Create zones where your location won't be shared with other riders")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
        }
      }
      
      Button("Enable Privacy Zones") {
        store.send(.togglePrivacyZones)
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      
      Spacer()
    }
  }
}

struct ZoneRow: View {
  let zone: PrivacyZone
  let onToggleActive: () -> Void
  let onDelete: () -> Void
    
  var body: some View {
    HStack(spacing: 12) {
      // Status indicator
      Circle()
        .fill(zone.isActive ? Color.green : Color.secondary)
        .frame(width: 8, height: 8)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(zone.name)
          .font(.body)
          .fontWeight(.medium)
        
        HStack(spacing: 16) {
          Label("\(Int(zone.radius))m", systemImage: "circle.dashed")
            .font(.caption)
            .foregroundColor(.secondary)
          
          Label(
            zone.createdAt
              .formatted(.dateTime.day().month().hour().minute()),
            systemImage: "calendar"
          )
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      Spacer()
      
      VStack(spacing: 4) {
        Toggle("", isOn: .constant(zone.isActive))
          .labelsHidden()
          .onChange(of: zone.isActive) {
            onToggleActive()
          }
        
        Text(zone.isActive ? "Active" : "Inactive")
          .font(.caption2)
          .foregroundColor(zone.isActive ? .green : .secondary)
      }
    }
    .padding(.vertical, 4)
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
      Button("Delete", role: .destructive) {
        onDelete()
      }
    }
    .opacity(zone.isActive ? 1.0 : 0.7)
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
