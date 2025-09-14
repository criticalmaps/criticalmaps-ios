import ComposableArchitecture
import SharedModels
import Styleguide
import SwiftUI

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
