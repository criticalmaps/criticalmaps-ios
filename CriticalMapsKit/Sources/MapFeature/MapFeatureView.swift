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
    self.viewStore = ViewStore(store)
  }
  
  let store: Store<MapFeatureState, MapFeatureAction>
  @ObservedObject var viewStore: ViewStore<MapFeatureState, MapFeatureAction>
  
  public var body: some View {
    ZStack(alignment: .topTrailing) {
      MapView(
        riderCoordinates: viewStore.riderLocations,
        userTrackingMode: viewStore.binding(
          get: { $0.userTrackingMode.mode },
          send: MapFeatureAction.updateUserTrackingMode
        ),
        shouldAnimateUserTrackingMode: viewStore.shouldAnimateTrackingMode,
        nextRide: viewStore.nextRide,
        centerRegion: viewStore.binding(
          get: \.centerRegion,
          send: MapFeatureAction.updateCenterRegion
        )
      )
      .edgesIgnoringSafeArea(.all)
      
      VStack {
        if viewStore.isNextRideBannerVisible {
          nextRideBanner
        } else {
          EmptyView()
        }
        
        offlineBanner
          .clipShape(Circle())
          .opacity(isConnected ? 0 : 1)
          .animation(.easeOut, value: isConnected)
      }
      .padding(.top, .grid(12))
      .padding(.horizontal)
    }
  }
  
  var offlineBanner: some View {
    Image(systemName: "wifi.slash")
      .foregroundColor(
        reduceTransparency
        ? Color.white
        : Color(.attention)
      )
      .accessibilityRepresentation { isConnected ? Text("internet connection available") : Text("internet not available") }
      .padding()
      .background(
        Group {
          if reduceTransparency {
            RoundedRectangle(
              cornerRadius: 12,
              style: .circular
            )
            .fill(reduceTransparency
                ? Color(.attention)
                : Color(.attention).opacity(0.8)
            )
          } else {
            Blur()
          }
        }
      )
  }
  
  var nextRideBanner: some View {
    MapOverlayView(
      store: store.actionless.scope(state: {
        MapOverlayView.ViewState(
          isVisible: $0.isNextRideBannerVisible,
          isExpanded: $0.isNextRideBannerExpanded
        )}
      ),
      action: { viewStore.send(.focusNextRide) },
      content: {
        VStack(alignment: .leading) {
          Text(viewStore.nextRide?.title ?? "")
            .font(.titleTwo)
            .foregroundColor(Color(.textPrimary))
          Text(viewStore.nextRide?.rideDateAndTime ?? "")
            .font(.bodyTwo)
            .foregroundColor(Color(.textSecondary))
        }
      }
    )
      .accessibilityElement(children: .contain)
      .accessibilityHint(Text(L10n.A11y.Mapfeatureview.Nextridebanner.hint))
      .accessibilityLabel(Text(L10n.A11y.Mapfeatureview.Nextridebanner.label))
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
