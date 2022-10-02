import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftUI

public struct TweetFeature: ReducerProtocol {
  public init() {}
  
  @Dependency(\.uiApplicationClient) public var uiApplicationClient
  
  public typealias State = Tweet
  
  public enum Action {
    case openTweet
  }

  public func reduce(into state: inout Tweet, action: Action) -> Effect<Action, Never> {
    switch action {
    case .openTweet:
      return .fireAndForget { [tweet = state] in
        _ = await uiApplicationClient.open(tweet.tweetUrl!, [:])
      }
    }
  }
}

/// A view that renders a tweet
public struct TweetView: View {
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
  
  let store: Store<TweetFeature.State, TweetFeature.Action>
  @ObservedObject var viewStore: ViewStore<TweetFeature.State, TweetFeature.Action>
  
  public init(store: Store<TweetFeature.State, TweetFeature.Action>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    ZStack {
      HStack(alignment: .top, spacing: .grid(4)) {
        AsyncImage(
          url: viewStore.state.user.profileImage,
          transaction: Transaction(animation: reduceMotion ? nil : .easeInOut)
        ) { phase in
          switch phase {
          case .empty:
            Color(.textSilent).opacity(0.6)
          case let .success(image):
            image
              .resizable()
              .transition(.opacity)
          case .failure:
            Color(.textSilent).opacity(0.6)
          @unknown default:
            EmptyView()
          }
        }
        .frame(width: 44, height: 44)
        .background(Color.gray)
        .clipShape(Circle())
        
        VStack(alignment: .leading, spacing: .grid(2)) {
          tweetheader
          
          Text(viewStore.state.makeAttributedTweet)
            .multilineTextAlignment(.leading)
            .font(.bodyOne)
            .foregroundColor(Color(.textSecondary))
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      viewStore.send(.openTweet)
    }
    .accessibilityAddTraits([.isButton])
    .accessibilityAction(
      action: { viewStore.send(.openTweet) },
      label: { Text("Open tweet")
        .accessibilityHint("Opens the tweet in the twitter app if it is installed")
      }
    )
    .accessibilityElement(children: .combine)
    .padding(.vertical, .grid(2))
  }
  
  var tweetheader: some View {
   Group {
      if dynamicTypeSize.isAccessibilitySize {
        VStack(alignment: .leading) {
          twitterUserName
          twitterScreenName
          tweetPostDatetime
        }
      } else {
        HStack {
          twitterUserName
          twitterScreenName
          Spacer()
          tweetPostDatetime
        }
      }
   }
    .accessibilityElement(children: .combine)
    .accessibilityRepresentation(representation: {
      HStack {
        twitterUserName
        Text("tweeted")
        tweetPostDatetime
      }
    })
  }
  
  var twitterUserName: some View {
    Text(viewStore.state.user.name)
      .lineLimit(1)
      .font(.titleTwo)
      .foregroundColor(Color(.textPrimary))
  }
  
  var twitterScreenName: some View {
    Text(viewStore.state.user.screenName)
      .lineLimit(1)
      .font(.bodyTwo)
      .foregroundColor(Color(.textSilent))
      .accessibilityHidden(true)
  }
  
  var tweetPostDatetime: some View {
    let (text, a11yValue) = viewStore.state.formattedCreationDate()
    return Text(text ?? "")
      .font(.meta)
      .foregroundColor(Color(.textPrimary))
      .accessibilityLabel(a11yValue ?? "")
  }
}

// MARK: Preview

struct TweetView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TweetView(
        store: .init(
          initialState: [Tweet].placeHolder[0],
          reducer: TweetFeature()
        )
      )
      
      TweetView(
        store: .init(
          initialState: [Tweet].placeHolder[0],
          reducer: TweetFeature()
        )
      )
      .redacted(reason: .placeholder)
    }
  }
}

public extension Tweet {
  var makeAttributedTweet: NSAttributedString {
    NSAttributedString.highlightMentionsAndTags(in: text)
  }
  
  func formattedCreationDate(
    currentDate: () -> Date = Date.init,
    calendar: () -> Calendar = { .current }
  ) -> (String?, String?) {
    let components = calendar().dateComponents(
      [.hour, .day, .month],
      from: createdAt,
      to: currentDate()
    )
    
    let a11yValue = RelativeDateTimeFormatter.tweetDateFormatter.localizedString(for: createdAt, relativeTo: currentDate())
    
    if let days = components.day, days == 0, let months = components.month, months == 0 {
      let diffComponents = calendar().dateComponents([.hour, .minute], from: createdAt, to: currentDate())
      
      let value = DateComponentsFormatter.tweetDateFormatter()
        .string(from: diffComponents.dateComponentFromBiggestComponent)
      return (value, a11yValue)
    } else {
        let value = DateFormatter.mediumDateFormatter.string(from: createdAt)
        return (value, a11yValue)
    }
  }
}

extension DateComponents {
  var dateComponentFromBiggestComponent: DateComponents {
    if let day = day, day != 0 {
      return DateComponents(calendar: calendar, day: day)
    } else if let hour = hour, hour != 0 {
      return DateComponents(calendar: calendar, hour: hour)
    } else {
      return DateComponents(calendar: calendar, minute: minute)
    }
  }
}

extension RelativeDateTimeFormatter {
  static let tweetDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    return formatter
  }()
}
