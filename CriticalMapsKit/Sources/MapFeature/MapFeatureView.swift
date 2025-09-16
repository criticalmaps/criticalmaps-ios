import ComposableArchitecture
import Helpers
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Shared(.privacyZoneSettings) var privacyZoneSettings: PrivacyZoneSettings

  @Bindable var store: StoreOf<MapFeature>

  public init(store: StoreOf<MapFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapView(
        riderCoordinates: store.riderLocations,
        userTrackingMode: $store.userTrackingMode.mode,
        nextRide: store.nextRide,
        rideEvents: store.rideEvents,
        privacyZones: privacyZoneSettings.zones,
        canShowPrivacyZonesOnMap: privacyZoneSettings.canShowOnMap,
        annotationsCount: $store.visibleRidersCount,
        centerRegion: $store.centerRegion,
        centerEventRegion: $store.eventCenter,
        mapMenuShareEventHandler: {
          store.send(.showShareSheet(true))
        },
        mapMenuRouteEventHandler: {
          store.send(.routeToEvent)
        }
      )
      .edgesIgnoringSafeArea(.all)
    }
    .sheet(
      isPresented: $store.presentShareSheet.animation(),
      onDismiss: { store.send(.showShareSheet(false)) },
      content: {
        ShareSheetView(activityItems: [store.nextRide?.shareMessage ?? ""])
      }
    )
  }
}

// MARK: Preview

#Preview {
  MapFeatureView(
    store: StoreOf<MapFeature>(
      initialState: MapFeature.State(
        riders: [],
        userTrackingMode: UserTrackingFeature.State(userTrackingMode: .follow)
      ),
      reducer: { MapFeature()._printChanges() }
    )
  )
}
