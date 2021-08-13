import ComposableArchitecture
import GuideFeature
import L10n
import MapFeature
import SettingsFeature
import Styleguide
import SwiftUI

public struct AppNavigationView: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>
  @Environment(\.colorScheme) var colorScheme
  
  let minHeight: CGFloat = 56
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    HStack {
      UserTrackingButton(
        store: store.scope(
          state: { $0.mapFeatureState.userTrackingMode },
          action: { AppAction.map(.userTracking($0)) }
        )
      )
      .frame(maxWidth: .infinity, minHeight: minHeight)
      menuSeperator
      
      // Chat
      chatButton
      menuSeperator
      
      // Rules
      rulesButton
      menuSeperator
      
      // Settings
      settingsButton
    }
    .font(.body)
    .background(Color(.backgroundTranslucent))
    .adaptiveCornerRadius(.allCorners, 18)
    .modifier(ShadowModifier())
  }
  
  var chatButton: some View {
    Button(
      action: {
        viewStore.send(.setNavigation(tag: .chat))
      },
      label: {
        Image(systemName: "bubble.left")
          .iconModifier()
          .accessibility(hidden: true)
      })
      .background(
        EmptyView()
          .sheet(
            isPresented: viewStore.binding(
              get: \.isChatViewPresented,
              send: { _ in AppAction.dismissSheetView }
            ),
            onDismiss: nil,
            content: {
              NavigationView {
                Text(L10n.Chat.title)
              }
              .navigationViewStyle(StackNavigationViewStyle())
              .navigationStyle(
                title: Text(L10n.Chat.title),
                navPresentationStyle: .modal,
                onDismiss: { viewStore.send(.dismissSheetView) }
              )
            }
          )
      )
      .accessibility(label: Text(L10n.Chat.title))
      .frame(maxWidth: .infinity, minHeight: minHeight)
  }
  
  var rulesButton: some View {
    Button(
      action: {
        viewStore.send(.setNavigation(tag: .rules))
      },
      label: {
        Image(systemName: "exclamationmark.square")
          .iconModifier()
          .accessibility(hidden: true)
      }
    )
    .background(
      EmptyView()
        .sheet(
          isPresented: viewStore.binding(
            get: \.isRulesViewPresented,
            send: { _ in AppAction.dismissSheetView }
          ),
          onDismiss: nil,
          content: {
            NavigationView {
              GuideView()
            }
            .accentColor(Color(.textPrimary))
            .navigationViewStyle(StackNavigationViewStyle())
          }
        )
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .accessibility(label: Text(L10n.Rules.title))
  }
  
  var settingsButton: some View {
    Button(
      action: {
        viewStore.send(.setNavigation(tag: .settings))
      },
      label: {
        Image(systemName: "gearshape")
          .iconModifier()
          .accessibility(hidden: true)
      }
    )
    .background(
      EmptyView()
        .sheet(
          isPresented: viewStore.binding(
            get: \.isSettingsViewPresented,
            send: { _ in AppAction.dismissSheetView }
          ),
          onDismiss: nil,
          content: {
            NavigationView {
              SettingsView(
                store: store.scope(
                  state: \.settingsState,
                  action: { AppAction.settings($0) }
                )
              )
              .dismissable()
            }
            .navigationViewStyle(StackNavigationViewStyle())
          }
        )
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .accessibility(label: Text(L10n.Settings.title))
  }
  
  var menuSeperator: some View {
    Color(.border)
      .frame(width: 1, height: minHeight)
  }
}

struct ShadowModifier: ViewModifier {
  @Environment(\.colorScheme) var colorScheme
  
  func body(content: Content) -> some View {
    Group {
      if colorScheme == .light {
        content
          .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0.0, y: 0.0)
      } else {
        content
      }      
    }
  }
}

// MARK: Preview
struct AppNavigationView_Previews: PreviewProvider {
  static var previews: some View {
    AppNavigationView(store: Store<AppState, AppAction>(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        service: .noop,
        idProvider: .noop,
        mainQueue: .failing,
        userDefaultsClient: .noop,
        infoBannerPresenter: .mock(),
        uiApplicationClient: .noop
      )
    )
    )
  }
}
