import ComposableArchitecture
import SharedModels
import SwiftUI

public struct PrivacyZoneMapContainerView: View {
  @Bindable var store: StoreOf<PrivacyZoneFeature>
  
  public init(store: StoreOf<PrivacyZoneFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        if store.settings.isEnabled {
          mapSection
        } else {
          disabledStateView
        }
      }
      .navigationTitle("Privacy Zone Map")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          NavigationLink("Settings") {
            PrivacyZoneSettingsView(store: store)
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          if store.settings.isEnabled {
            Button("Add Zone", systemImage: "plus") {
              store.send(.addZoneButtonTapped)
            }
          }
        }
      }
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
    }
  }
  
  @ViewBuilder
  private var mapSection: some View {
    VStack(spacing: 16) {
      PrivacyZoneMapView(
        zones: .constant(store.settings.zones.elements),
        selectedZone: $store.selectedZone,
        isCreatingZone: .constant(false),
        newZoneRadius: .constant(400),
        mapCenter: .constant(nil),
        showZones: store.settings.showZonesOnMap
      ) { _ in
        // Map tap handling can be removed since we're using sheet-based creation
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .cornerRadius(12)
      .padding(.horizontal)
      
      if !store.settings.zones.isEmpty {
        zoneQuickToggle
      }
    }
  }
  
  @ViewBuilder
  private var zoneQuickToggle: some View {
    VStack(spacing: 12) {
      HStack {
        Text("Quick Zone Toggle")
          .font(.headline)
        Spacer()
        Button("Show All Zones", systemImage: store.settings.showZonesOnMap ? "eye.slash" : "eye") {
          store.send(.toggleShowZonesOnMap)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
      }
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(store.settings.zones) { zone in
            ZoneToggleChip(
              zone: zone,
              isSelected: store.selectedZone?.id == zone.id,
              onToggle: { store.send(.toggleZoneActive(zone)) },
              onSelect: { store.send(.selectZone(zone)) }
            )
          }
        }
        .padding(.horizontal)
      }
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
    .padding(.horizontal)
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

struct ZoneToggleChip: View {
  let zone: PrivacyZone
  let isSelected: Bool
  let onToggle: () -> Void
  let onSelect: () -> Void
  
  var body: some View {
    HStack(spacing: 8) {
      Button(action: onToggle) {
        Image(systemName: zone.isActive ? "checkmark.circle.fill" : "circle")
          .foregroundColor(zone.isActive ? .green : .secondary)
      }
      .buttonStyle(.plain)
      
      VStack(alignment: .leading, spacing: 2) {
        Text(zone.name)
          .font(.caption)
          .fontWeight(.medium)
          .lineLimit(1)
        
        Text("\(Int(zone.radius))m")
          .font(.caption2)
          .foregroundColor(.secondary)
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(isSelected ? Color.accentColor.opacity(0.2) : Color(.systemGray5))
        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
    )
    .opacity(zone.isActive ? 1.0 : 0.6)
    .onTapGesture {
      onSelect()
    }
  }
}

#Preview {
  PrivacyZoneMapContainerView(
    store: Store(initialState: PrivacyZoneFeature.State()) {
      PrivacyZoneFeature()
    }
  )
}
