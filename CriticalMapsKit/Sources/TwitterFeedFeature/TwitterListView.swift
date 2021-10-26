import ComposableArchitecture
import Foundation
import Kingfisher
import Styleguide
import SwiftUI
import SharedModels

public struct TweetListView: View {
  let store: Store<TwitterFeedState, TwitterFeedAction>
  @ObservedObject var viewStore: ViewStore<TwitterFeedState, TwitterFeedAction>
  
  public init(store: Store<TwitterFeedState, TwitterFeedAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    List(viewStore.tweets) { tweet in
      HStack(alignment: .top, spacing: .grid(4)) {
        KFImage.url(tweet.user.profileImage)
          .placeholder { Color(.textSilent).opacity(0.6) }
          .fade(duration: 0.2)
          .resizable()
          .scaledToFit()
          .cornerRadius(20)
          .frame(width: 40, height: 40)
        
        VStack(alignment: .leading, spacing: .grid(2)) {
          HStack {
            Text(tweet.user.name)
              .lineLimit(1)
              .font(.titleTwo)
              .foregroundColor(Color(.textPrimary))
            Text(tweet.user.screenName)
              .lineLimit(1)
              .font(.bodyTwo)
              .foregroundColor(Color(.textSilent))
            Spacer()
            if let dateString = tweet.dateString() {
              Text(dateString)
                .font(.meta)
                .foregroundColor(Color(.textPrimary))
            }
          }
          Text(tweet.text)
            .multilineTextAlignment(.leading)
            .font(.bodyOne)
            .foregroundColor(Color(.textSecondary))
        }
        .onTapGesture {
          viewStore.send(.openTweet(tweet))
        }
      }
    }
    .listStyle(InsetListStyle())
  }
}

// MARK: Preview
struct TweetListView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TweetListView(
        store: Store<TwitterFeedState, TwitterFeedAction>(
          initialState: TwitterFeedState(tweets: .placeHolder),
          reducer: twitterFeedReducer,
          environment: TwitterFeedEnvironment(
            service: .noop,
            mainQueue: .failing,
            uiApplicationClient: .noop
          )
        )
      )
      
      TweetListView(
        store: .placeholder
      )
        .redacted(reason: .placeholder)
    }
  }
}


extension Tweet {
  func dateString(
    currentDate: Date = Date(),
    calendar: Calendar = .current
  ) -> String? {
    let components = calendar.dateComponents(
      [.second, .minute, .hour, .day, .month],
      from: createdAt,
      to: currentDate
    ).dateComponentFromBiggestComponent
    
    let formatter = DateComponentsFormatter.tweetDateFormatter(calendar)
    return formatter.string(from: components)?.uppercased()
  }
  
  static func hoursAndMinutesDateString(from message: ChatMessage, calendar: Calendar = .current) -> String {
    let date = Date(timeIntervalSince1970: message.timestamp)
    let formatter = DateFormatter.localeShortTimeFormatter
    formatter.calendar = calendar
    formatter.timeZone = calendar.timeZone
    return formatter.string(from: date)
  }
}

extension DateComponents {
  var dateComponentFromBiggestComponent: DateComponents {
    if let month = month,
       month != 0
    {
      return DateComponents(calendar: calendar, month: month)
    } else if let day = day,
              day != 0
    {
      return DateComponents(calendar: calendar, day: day)
    } else if let hour = hour,
              hour != 0
    {
      return DateComponents(calendar: calendar, hour: hour)
    } else if let minute = minute,
              minute != 0
    {
      return DateComponents(calendar: calendar, minute: minute)
    } else {
      return DateComponents(calendar: calendar, second: second)
    }
  }
}
