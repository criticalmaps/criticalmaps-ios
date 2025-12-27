import ComposableArchitecture
import Foundation
import MastodonKit

public extension TootFeature.State {
  init(_ status: MastodonKit.Status) {
    self.init(
      id: status.id,
      createdAt: status.createdAt,
      uri: status.uri,
      accountURL: status.account.url,
      accountAvatar: status.account.avatar,
      accountDisplayName: status.account.displayName,
      accountAcct: status.account.acct,
      content: status.content,
      mediaAttachments: status.mediaAttachments
    )
  }
  
  func formattedCreationDate() -> (String?, String?) {
    @Dependency(\.date.now) var date
    @Dependency(\.calendar) var calendar
    
    let components = calendar.dateComponents(
      [.hour, .day, .month],
      from: createdAt,
      to: date
    )
    
    let a11yValue = createdAt.formatted(.relativeToTootDate)
    
    if let days = components.day, days == 0, let months = components.month, months == 0 {
      let value = tweetDateFormatted(from: createdAt, to: date, calendar: calendar)
      return (value, a11yValue)
    } else {
      let value = createdAt.formatted(Date.FormatStyle.dateWithoutYear)
      return (value, a11yValue)
    }
  }
  
  private func tweetDateFormatted(
    from: Date,
    to: Date,
    calendar: Calendar = .current
  ) -> String {
    let timeInterval = to.timeIntervalSince(from)
    let duration = Duration.seconds(timeInterval)
    
    return duration.formatted(
      .units(
        allowed: [.days, .hours, .minutes],
        width: .abbreviated,
        maximumUnitCount: 1
      )
    )
  }
}

struct TootDate: FormatStyle {
  typealias FormatInput = Date
  typealias FormatOutput = String
  
  static let relativeToTootDate = Date.RelativeFormatStyle(presentation: .named)
  
  func format(_ value: Date) -> String {
    TootDate.relativeToTootDate.format(value)
  }
}

extension FormatStyle where Self == TootDate {
  static var relativeToTootDate: TootDate { TootDate() }
}
