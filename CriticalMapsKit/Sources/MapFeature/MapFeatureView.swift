import ComposableArchitecture
import Helpers
import L10n
import SharedDependencies
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  
  @Bindable var store: StoreOf<MapFeature>

  public init(store: StoreOf<MapFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapView(
        riderCoordinates: store.riderLocations,
        userTrackingMode: Binding(
          get: { store.userTrackingMode },
          set: { store.send(.binding(.set(\.userTrackingMode, $0))) }
        ),
        nextRide: store.nextRide,
        rideEvents: store.rideEvents,
        annotationsCount: Binding(
          get: { store.visibleRidersCount },
          set: { store.send(.binding(.set(\.visibleRidersCount, $0))) }
        ),
        centerRegion: Binding(
          get: { store.centerRegion },
          set: { store.send(.binding(.set(\.centerRegion, $0))) }
        ),
        centerEventRegion: Binding(
          get: { store.eventCenter },
          set: { store.send(.binding(.set(\.eventCenter, $0))) }
        ),
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
      isPresented: Binding<Bool>(
        get: { store.presentShareSheet },
        set: { store.send(.showShareSheet($0)) }
      ),
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
