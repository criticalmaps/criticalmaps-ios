import ComposableArchitecture
import SwiftUI

// MARK: Form

/// A view to unify style for form like view
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

struct SettingsRow<Content: View>: View {
  let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var body: some View {
    VStack(alignment: .leading) {
      self.content()
        .padding(.vertical, .grid(2))
        .padding(.horizontal, .grid(4))
        .contentShape(Rectangle())
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

/// A view to wrap a form section.
public struct SettingsSection<Content: View>: View {
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
      if !title.isEmpty {
        Text(self.title)
          .font(.headlineTwo)
          .padding([.leading, .bottom], .grid(4))
          .padding(.top, .grid(6))
          .accessibilityAddTraits(.isHeader)
      }

      self.content()
    }
  }
}

// MARK: SettingsNavigationLink

/// A view to that wraps the input view in a SettingsRow and NavigationLink
public struct SettingsNavigationLink<Destination: View, Label: View>: View {
  let destination: () -> Destination
  let title: () -> Label

  public init(
    @ViewBuilder destination: @escaping () -> Destination,
    @ViewBuilder title: @escaping () -> Label
  ) {
    self.destination = destination
    self.title = title
  }

  public var body: some View {
    SettingsRow {
      NavigationLink(
        destination: destination,
        label: { content }
      )
    }
  }

  var content: some View {
    HStack {
      title()
        .font(.titleOne)
      Spacer()
      Image(systemName: "chevron.forward")
        .font(.titleOne)
        .accessibilityHidden(true)
    }
  }
}
