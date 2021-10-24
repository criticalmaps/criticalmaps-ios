import ComposableArchitecture
import GuideFeature
import L10n
import MapFeature
import SettingsFeature
import Styleguide
import SwiftUI
import TwitterFeedFeature

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
              TwitterFeedView(
                store: store.scope(
                  state: \.twitterFeedState,
                  action: AppAction.twitter
                )
              )
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
            CMNavigationView {
              GuideView()
            }
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
            CMNavigationView {
              SettingsView(
                store: store.scope(
                  state: \.settingsState,
                  action: { AppAction.settings($0) }
                )
              )
              .dismissable()
            }
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

// MARK: Preview
struct AppNavigationView_Previews: PreviewProvider {
  static var previews: some View {
    AppNavigationView(
      store: Store<AppState, AppAction>(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
          service: .noop,
          idProvider: .noop,
          mainQueue: .failing,
          userDefaultsClient: .noop,
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
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

struct CMNavigationView<Content>: View where Content: View {
  let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    NavigationView {
      content()
    }
    .accentColor(Color(.textPrimary))
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
