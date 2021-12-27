import ChatFeature
import ComposableArchitecture
import SwiftUI
import TwitterFeedFeature

/// A view that holds the chatfeature and twitterfeature and just offers a control to switch between the two.
public struct SocialView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let store: Store<SocialState, SocialAction>
  @ObservedObject var viewStore: ViewStore<SocialState, SocialAction>
  
  public init(store: Store<SocialState, SocialAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  public var body: some View {
    NavigationView {
      Group {
        switch viewStore.socialControl {
        case .chat:
          ChatView(
            store: store.scope(
              state: \.chatFeautureState,
              action: SocialAction.chat
            )
          )
        case .twitter:
          TwitterFeedView(
            store: store.scope(
              state: \.twitterFeedState,
              action: SocialAction.twitter
            )
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: { presentationMode.wrappedValue.dismiss() },
            label: {
              Image(systemName: "xmark")
                .font(Font.system(size: 22, weight: .medium))
                .foregroundColor(Color(.textPrimary))
            }
          )
        }
        
        ToolbarItem(placement: .principal) {
          Picker(
            "Social Segment",
            selection: viewStore.binding(
              get: \.socialControl.rawValue,
              send: { SocialAction.setSocialSegment(.init($0)) }
            )
          ) {
            Text(SocialState.SocialControl.chat.title).tag(0)
            Text(SocialState.SocialControl.twitter.title).tag(1)
          }
          .pickerStyle(SegmentedPickerStyle())
          .frame(maxWidth: 180)
        }
      }
    }
  }
}

// MARK: Preview
struct SocialView_Previews: PreviewProvider {
  static var previews: some View {
    SocialView(store: Store<SocialState, SocialAction>(
      initialState: SocialState(
        chatFeautureState: .init(),
        twitterFeedState: .init()
      ),
      reducer: socialReducer,
      environment: SocialEnvironment(
        mainQueue: .failing,
        uiApplicationClient: .noop,
        locationsAndChatDataService: .noop,
        idProvider: .noop,
        uuid: UUID.init,
        date: Date.init,
        userDefaultsClient: .noop
      )
    )
    )
  }
}
