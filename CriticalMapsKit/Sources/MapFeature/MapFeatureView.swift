import ComposableArchitecture
import Helpers
import L10n
import SharedEnvironment
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  @Environment(\.connectivity) var isConnected

  public init(store: Store<MapFeatureState, MapFeatureAction>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  let store: Store<MapFeatureState, MapFeatureAction>
  @ObservedObject var viewStore: ViewStore<MapFeatureState, MapFeatureAction>

  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapView(
        riderCoordinates: viewStore.riderLocations,
        userTrackingMode: viewStore.binding(
          get: { $0.userTrackingMode.mode },
          send: MapFeatureAction.updateUserTrackingMode
        ),
        shouldAnimateUserTrackingMode: viewStore.shouldAnimateTrackingMode,
        nextRide: viewStore.nextRide,
        rideEvents: viewStore.rideEvents,
        centerRegion: viewStore.binding(
          get: \.centerRegion,
          send: MapFeatureAction.updateCenterRegion
        ),
        centerEventRegion: viewStore.binding(
          get: \.eventCenter,
          send: MapFeatureAction.updateCenterRegion
        ),
        mapMenuShareEventHandler: {
          viewStore.send(.showShareSheet(true))
        },
        mapMenuRouteEventHandler: {
          viewStore.send(.routeToEvent)
        }
      )
      .edgesIgnoringSafeArea(.all)
    }
    .sheet(
      isPresented: viewStore.binding(
        get: \.presentShareSheet,
        send: MapFeatureAction.showShareSheet
      ),
      onDismiss: { viewStore.send(.showShareSheet(false)) },
      content: {
        ShareSheetView(activityItems: [viewStore.nextRide?.shareMessage ?? ""])
      }
    )
  }
}

// MARK: Preview

struct MapFeatureView_Previews: PreviewProvider {
  static var previews: some View {
    MapFeatureView(
      store: Store<MapFeatureState, MapFeatureAction>(
        initialState: MapFeatureState(
          riders: [],
          userTrackingMode: UserTrackingState(userTrackingMode: .follow)
        ),
        reducer: mapFeatureReducer,
        environment: MapFeatureEnvironment(
          locationManager: .live,
          mainQueue: .failing
        )
      )
    )
  }
}
