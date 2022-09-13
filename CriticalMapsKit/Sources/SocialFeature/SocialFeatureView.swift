import ChatFeature
import ComposableArchitecture
import SwiftUI
import TwitterFeedFeature

/// A view that holds the chatfeature and twitterfeature and just offers a control to switch between the two.
public struct SocialView: View {
  @Environment(\.presentationMode) var presentationMode

  typealias State = SocialFeature.State
  typealias Action = SocialFeature.Action

  let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<State, Action>

  public init(store: Store<SocialFeature.State, SocialFeature.Action>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  public var body: some View {
    NavigationView {
      Group {
        switch viewStore.socialControl {
        case .chat:
          ChatView(
            store: store.scope(
              state: \.chatFeautureState,
              action: SocialFeature.Action.chat
            )
          )
        case .twitter:
          TwitterFeedView(
            store: store.scope(
              state: \.twitterFeedState,
              action: SocialFeature.Action.twitter
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
              send: SocialFeature.Action.setSocialSegment
            )
          ) {
            Text(SocialFeature.SocialControl.chat.title).tag(0)
            Text(SocialFeature.SocialControl.twitter.title).tag(1)
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
    SocialView(
      store: Store<SocialFeature.State, SocialFeature.Action>(
        initialState: SocialFeature.State(
          chatFeautureState: .init(),
          twitterFeedState: .init()
        ),
        reducer: SocialFeature()
      )
    )
  }
}
