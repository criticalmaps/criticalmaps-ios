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
  @State private var showsInfoExpanded = false
  @State private var store: StoreOf<AppFeature>
  
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapFeatureView(
        store: store.scope(state: \.mapFeatureState, action: \.map)
      )
      .edgesIgnoringSafeArea(.vertical)
      
      HStack {
        VStack(alignment: .leading) {
          if store.shouldShowNextRideBanner {
            nextRideBanner()
          }
          
          if store.userSettings.showInfoViewEnabled {
            ZStack(alignment: .center) {
              Blur()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .frame(width: showsInfoExpanded ? 120 : 50, height: showsInfoExpanded ? 230 : 50)
                .accessibleAnimation(.cmSpring.speed(1.5), value: showsInfoExpanded)
              
              infoContent()
            }
            .padding(.bottom, .grid(2))
          }
          
          if store.hasOfflineError {
            offlineBanner()
              .clipShape(Circle())
              .opacity(store.hasOfflineError ? 1 : 0)
              .accessibleAnimation(.easeInOut(duration: 0.2), value: store.hasOfflineError)
          }
        }
        .padding(.top, .grid(1))
        
        Spacer()
      }
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
      .padding(.horizontal, .grid(8))
    }
    .bottomSheet(
      bottomSheetPosition: $store.bottomSheetPosition,
      switchablePositions: [
        .relative(0.3),
        .relativeTop(0.975)
      ],
      title: "Events",
      content: { bottomSheetContentView() }
    )
    .showCloseButton()
    .backgroundBlurMaterial(.adaptive(.ultraThin))
    .showDragIndicator(true)
    .enableSwipeToDismiss()
    .onDismiss { store.send(.set(\.bottomSheetPosition, .hidden)) }
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    .onAppear { store.send(.onAppear) }
    .onDisappear { store.send(.onDisappear) }
  }
  
  @ViewBuilder
  func infoContent() -> some View {
    if showsInfoExpanded {
      VStack {
        Text("Info")
          .foregroundColor(Color(.textPrimary))
          .font(.titleTwo)
        
        DataTile("Next update") {
          CircularProgressView(progress: store.timerProgress)
            .frame(width: 44, height: 44)
            .overlay(alignment: .center) {
              if store.isRequestingRiderLocations {
                ProgressView()
              } else {
                Text(verbatim: store.timerValue)
                  .foregroundColor(Color(.textPrimary))
                  .font(.system(size: 14).bold())
                  .monospacedDigit()
                  .modifier(NumericContentTransition())
              }
            }
            .padding(.top, .grid(1))
        }
        
        DataTile("Riders") {
          HStack {
            Text(store.ridersCount)
              .font(.pageTitle)
              .modifier(NumericContentTransition())
          }
          .foregroundColor(Color(.textPrimary))
        }
      }
      .transition(
        .asymmetric(
          insertion: .opacity.combined(with: .scale(scale: 1, anchor: .topLeading)).animation(.easeIn(duration: 0.2)),
          removal: .opacity.combined(with: .scale(scale: 0, anchor: .topLeading)).animation(.easeIn(duration: 0.12))
        )
      )
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation { showsInfoExpanded = false }
      }
    } else {
      Button(
        action: { withAnimation { showsInfoExpanded = true } },
        label: {
          Image(systemName: "info.circle")
            .resizable()
            .frame(width: 30, height: 30)
            .transition(
              .asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0, anchor: .bottomLeading)).animation(.easeIn(duration: 0.1)),
                removal: .opacity.animation(.easeIn(duration: 0.1))
              )
            )
        }
      )
      .foregroundStyle(Color(.textPrimary))
    }
  }
  
  @ViewBuilder
  func bottomSheetContentView() -> some View {
    VStack {
      List(store.nextRideState.rideEvents, id: \.id) { ride in
        RideEventView(ride: ride)
          .contentShape(Rectangle())
          .padding(.vertical, .grid(1))
          .accessibilityElement(children: .combine)
          .onTapGesture {
            store.send(.onRideSelectedFromBottomSheet(ride))
          }
          .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
    }
    .accessibilityAction(.escape) {
      store.send(.set(\.bottomSheetPosition, .hidden))
    }
  }
  
  @ViewBuilder
  func offlineBanner() -> some View {
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
            RoundedRectangle(cornerRadius: 8, style: .circular)
              .fill(reduceTransparency ? Color(.attention) : Color(.attention).opacity(0.8))
          } else {
            Blur()
          }
        }
      )
  }
  
  @ViewBuilder
  func nextRideBanner() -> some View {
    MapOverlayView(
      store: store.scope(state: \.mapOverlayState, action: \.mapOverlayAction),
      content: {
        VStack(alignment: .leading, spacing: .grid(1)) {
          Text(store.nextRideState.nextRide?.titleWithoutDatePattern ?? "")
            .multilineTextAlignment(.leading)
            .font(.titleTwo)
            .foregroundColor(Color(.textPrimary))
          Text(store.state.nextRideState.nextRide?.rideDateAndTime ?? "")
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

// MARK: - Preview

#Preview {
  AppView(
    store: StoreOf<AppFeature>(
      initialState: .init(),
      reducer: { AppFeature()._printChanges() }
    )
  )
}

// MARK: - Helper

struct NumericContentTransition: ViewModifier {
  func body(content: Content) -> some View {
    content
      .contentTransition(.numericText())
  }
}
