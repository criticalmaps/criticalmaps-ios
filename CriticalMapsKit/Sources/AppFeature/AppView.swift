import BottomSheet
import ComposableArchitecture
import L10n
import MapFeature
import SharedEnvironment
import SharedModels
import Styleguide
import SwiftUI

/// The apps main view
public struct AppView: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency

  @State var presentBottomSheet = false

  let minHeight: CGFloat = 56
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
    viewStore = ViewStore(store)
  }
  
  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapFeatureView(
        store: store.scope(
          state: \.mapFeatureState,
          action: AppAction.map
        )
      )
      .edgesIgnoringSafeArea(.vertical)

      VStack(alignment: .leading) {
        if viewStore.state.mapFeatureState.isNextRideBannerVisible {
          nextRideBanner
            .contextMenu {
              Button(
                action: { viewStore.send(.setEventsBottomSheet(!viewStore.presentEventsBottomSheet)) },
                label: {
                  let title = viewStore.presentEventsBottomSheet ? L10n.Map.NextRideEvents.hideAll : L10n.Map.NextRideEvents.showAll
                  Label(title, systemImage: "list.bullet")
                }
              )
            }
        }

        offlineBanner
          .clipShape(Circle())
          .opacity(viewStore.hasConnectivity ? 0 : 1)
          .accessibleAnimation(.easeOut, value: viewStore.hasConnectivity)
      }
      .padding(.top, .grid(2))
      .padding(.horizontal)

      VStack {
        Spacer()
        
        AppNavigationView(store: store)
          .accessibilitySortPriority(1)
          .padding(.horizontal)
          .padding(.bottom, .grid(7))
          .frame(maxWidth: 400)
      }
    }
    .bottomSheet(
      isPresented: viewStore.binding(
        get: \.presentEventsBottomSheet,
        send: AppAction.setEventsBottomSheet
      ),
      detents: [.medium()],
      largestUndimmedDetentIdentifier: .medium,
      prefersGrabberVisible: true,
      prefersScrollingExpandsWhenScrolledToEdge: true,
      prefersEdgeAttachedInCompactHeight: true,
      selectedDetentIdentifier: .constant(nil),
      widthFollowsPreferredContentSizeWhenEdgeAttached: true,
      isModalInPresentation: false,
      onDismiss: { viewStore.send(.setEventsBottomSheet(false)) },
      contentView: {
        VStack {
          HStack {
            Text("Events")
              .foregroundColor(Color(.textPrimary))
              .font(.title2)
              .bold()

            Spacer()

            Button(
              action: { viewStore.send(.setEventsBottomSheet(false)) },
              label: {
                Image(systemName: "xmark.circle.fill")
                  .resizable()
                  .frame(width: .grid(8), height: .grid(8))
                  .foregroundColor(Color(.lightGray))
              }
            )
          }
          .accessibility(addTraits: [.isHeader])
          .padding(.grid(3))

          List(viewStore.nextRideState.rideEvents, id: \.id) { ride in
            HStack(alignment: .center, spacing: .grid(2)) {
              Image(uiImage: Asset.cm.image)
                .accessibilityHidden(true)

              VStack(alignment: .leading, spacing: .grid(1)) {
                Text(ride.title)
                  .multilineTextAlignment(.leading)
                  .font(.titleTwo)
                  .foregroundColor(Color(.textPrimary))
                Text(ride.rideDateAndTime)
                  .multilineTextAlignment(.leading)
                  .font(.bodyTwo)
                  .foregroundColor(Color(.textSecondary))
              }
            }
            .accessibilityElement(children: .combine)
            .contentShape(Rectangle())
            .onTapGesture {
              if let coordinate = ride.coordinate {
                viewStore.send(
                  .map(
                    .focusRideEvent(
                      Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    )
                  )
                )
              }
            }
          }
          .listStyle(.plain)
        }
        .accessibilityAction(.escape) {
          viewStore.send(.setEventsBottomSheet(false))
        }
      }
    )
    .environment(\.connectivity, viewStore.hasConnectivity)
    .onAppear { viewStore.send(.onAppear) }
    .onDisappear { viewStore.send(.onDisappear) }
  }

  var offlineBanner: some View {
    Image(systemName: "wifi.slash")
      .foregroundColor(
        reduceTransparency
          ? Color.white
          : Color(.attention)
      )
      .accessibilityRepresentation { viewStore.hasConnectivity ? Text("internet connection available") : Text("internet not available") }
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
          isVisible: $0.mapFeatureState.isNextRideBannerVisible,
          isExpanded: $0.mapFeatureState.isNextRideBannerExpanded
        )
      }
      ),
      action: { viewStore.send(.map(.focusNextRide(viewStore.nextRideState.nextRide?.coordinate))) },
      content: {
        VStack(alignment: .leading, spacing: .grid(1)) {
          Text(viewStore.state.nextRideState.nextRide?.title ?? "")
            .multilineTextAlignment(.leading)
            .font(.titleTwo)
            .foregroundColor(Color(.textPrimary))
          Text(viewStore.state.nextRideState.nextRide?.rideDateAndTime ?? "")
            .multilineTextAlignment(.leading)
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

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store<AppState, AppAction>(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .noop,
        idProvider: .noop,
        mainQueue: .failing,
        uiApplicationClient: .noop,
        setUserInterfaceStyle: { _ in .none }
      )
    )
    )
  }
}
