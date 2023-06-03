import BottomSheet
import ComposableArchitecture
import L10n
import MapFeature
import SharedDependencies
import SharedModels
import Styleguide
import SwiftUI

/// The apps main view
public struct AppView: View {
  let store: Store<AppFeature.State, AppFeature.Action>
  @ObservedObject var viewStore: ViewStore<AppFeature.State, AppFeature.Action>

  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass

  @State private var showOfflineBanner = false

  private let minHeight: CGFloat = 56
  public init(store: Store<AppFeature.State, AppFeature.Action>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  private var contextMenuTitle: String {
    if viewStore.bottomSheetPosition == .hidden {
      return L10n.Map.NextRideEvents.showAll
    } else {
      return L10n.Map.NextRideEvents.hideAll
    }
  }
  
  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapFeatureView(
        store: store.scope(
          state: \.mapFeatureState,
          action: AppFeature.Action.map
        )
      )
      .edgesIgnoringSafeArea(.vertical)

      VStack(alignment: .leading) {
        if viewStore.state.mapFeatureState.isNextRideBannerVisible {
          nextRideBanner
            .contextMenu {
              Button(
                action: { viewStore.send(.set(\.$bottomSheetPosition, .relative(0.4))) },
                label: { Label(contextMenuTitle, systemImage: "list.bullet") }
              )
            }
        }

        if !viewStore.connectionObserverState.isNetworkAvailable || viewStore.hasOfflineError {
          offlineBanner
            .clipShape(Circle())
            .opacity(showOfflineBanner ? 1 : 0)
            .accessibleAnimation(.easeOut, value: showOfflineBanner)
        }
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
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .bottomSheet(
      bottomSheetPosition: viewStore.binding(\.$bottomSheetPosition),
      switchablePositions: [
        .relative(0.4),
        .relativeTop(0.975)
      ],
      title: "Events",
      content: { bottomSheetContentView() }
    )
    .showCloseButton()
    .backgroundBlurMaterial(.adaptive(.thin))
    .showDragIndicator(true)
    .enableSwipeToDismiss()
    .onDismiss { viewStore.send(.set(\.$bottomSheetPosition, .hidden)) }
    .alert(store.scope(state: \.alert), dismiss: .dismissAlert)
    .onAppear { viewStore.send(.onAppear) }
    .onDisappear { viewStore.send(.onDisappear) }
    .onChange(of: viewStore.connectionObserverState.isNetworkAvailable) { newValue in
      self.showOfflineBanner = !newValue
    }
  }

  func bottomSheetContentView() -> some View {
    VStack {
      List(viewStore.nextRideState.rideEvents, id: \.id) { ride in
        HStack(alignment: .center, spacing: .grid(2)) {
          Image(uiImage: Asset.cm.image)
            .accessibilityHidden(true)

          VStack(alignment: .leading, spacing: .grid(1)) {
            Text(ride.title)
              .multilineTextAlignment(.leading)
              .font(Font.body.weight(.semibold))
              .foregroundColor(Color(.textPrimary))
              .padding(.bottom, .grid(1))

            VStack(alignment: .leading, spacing: 2) {
              Label(ride.dateTime.humanReadableDate, systemImage: "calendar")
                .multilineTextAlignment(.leading)
                .font(.bodyTwo)
                .foregroundColor(Color(.textSecondary))

              Label(ride.dateTime.humanReadableTime, systemImage: "clock")
                .multilineTextAlignment(.leading)
                .font(.bodyTwo)
                .foregroundColor(Color(.textSecondary))

              if let location = ride.location {
                Label(location, systemImage: "location.fill")
                  .multilineTextAlignment(.leading)
                  .font(.bodyTwo)
                  .foregroundColor(Color(.textSecondary))
              }
            }
          }
          Spacer()
        }
        .contentShape(Rectangle())
        .padding(.vertical, .grid(1))
        .accessibilityElement(children: .combine)
        .onTapGesture {
          viewStore.send(.onRideSelectedFromBottomSheet(ride))
        }
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
    }
    .accessibilityAction(.escape) {
      viewStore.send(.set(\.$bottomSheetPosition, .hidden))
    }
  }

  var offlineBanner: some View {
    Image(systemName: "wifi.slash")
      .foregroundColor(
        reduceTransparency
          ? Color.white
          : Color(.attention)
      )
      .accessibilityLabel(Text("Internet not available"))
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
      }),
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
    AppView(
      store: Store<AppFeature.State, AppFeature.Action>(
        initialState: .init(),
        reducer: AppFeature()._printChanges()
      )
    )
  }
}
