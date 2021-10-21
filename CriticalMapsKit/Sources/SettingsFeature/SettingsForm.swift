import ComposableArchitecture
import SwiftUI

// MARK: Form
public struct SettingsForm<Content>: View where Content: View {
  let content: () -> Content

  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  public var body: some View {
    ScrollView {
      self.content()
        .font(.titleOne)
        .toggleStyle(SwitchToggleStyle(tint: Color(.brand500)))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}


// MARK: Row
struct SettingsRow<Content>: View where Content: View {
  let content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      self.content()
        .padding(.vertical, .grid(2))
        .padding(.horizontal, .grid(4))
      seperator
        .accessibilityHidden(true)
    }
  }
  
  var seperator: some View {
    Rectangle()
      .fill(Color(.border))
      .frame(maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
  }
}


// MARK: Section
public struct SettingsSection<Content>: View where Content: View {
  let content: () -> Content
  let padContents: Bool
  let title: String
  
  public init(
    title: String,
    padContents: Bool = false,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content
    self.padContents = padContents
    self.title = title
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      if (!title.isEmpty) {
        Text(self.title)
          .font(.headlineTwo)
          .padding([.leading, .bottom], .grid(4))
          .padding(.top, .grid(10))
      }
      
      self.content()
    }
  }
}


// MARK: SettingsNavigationLink
public struct SettingsNavigationLink<Destination>: View where Destination: View {
  public enum NavigationType: Equatable {
    case openURL
    case routing
  }
  
  let destination: Destination
  let title: String
  let navigationType: NavigationType
  let openURL: () -> Void
  
  public init(
    destination: Destination,
    title: String,
    navigationType: SettingsNavigationLink<Destination>.NavigationType = .routing,
    openURL: @escaping () -> Void = {}
  ) {
    self.destination = destination
    self.title = title
    self.navigationType = navigationType
    self.openURL = openURL
  }
  
  public var body: some View {
    SettingsRow {
      if navigationType == .routing {
        NavigationLink(
          destination: self.destination,
          label: { content }
        )
      } else {
        Button(
          action: openURL,
          label: { content }
        )
      }
    }
    .foregroundColor(Color(.textPrimary))
  }
  
  var content: some View {
    HStack {
      Text(self.title)
        .font(.titleOne)
      Spacer()
      Image(systemName: "chevron.forward")
        .font(.titleOne)
        .accessibilityHidden(true)
    }
  }
}
