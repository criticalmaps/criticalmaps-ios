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
      let value = tootDateFormatted(from: createdAt, to: date)
      return (value, a11yValue)
    } else {
      let value = createdAt.formatted(Date.FormatStyle.dateWithoutYear)
      return (value, a11yValue)
    }
  }
  
  private func tootDateFormatted(
    from: Date,
    to: Date
  ) -> String {
    @Dependency(\.calendar) var calendar
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

private struct TootDate: FormatStyle {
  typealias FormatInput = Date
  typealias FormatOutput = String
	
  static let relativeToTootDate = Date.RelativeFormatStyle(presentation: .named)
	
  func format(_ value: Date) -> String {
    TootDate.relativeToTootDate.format(value)
  }
}

private extension FormatStyle where Self == TootDate {
  static var relativeToTootDate: TootDate { TootDate() }
}
