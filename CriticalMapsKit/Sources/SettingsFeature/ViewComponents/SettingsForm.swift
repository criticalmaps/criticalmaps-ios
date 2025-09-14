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
    List {
      content()
        .toggleStyle(SwitchToggleStyle(tint: Color(.brand600)))
        .foregroundStyle(Color(.textPrimary))
    }
    .listStyle(.insetGrouped)
  }
}

// MARK: Row

struct SettingsRow<Content: View>: View {
  let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var body: some View {
    HStack {
      content()
        .font(.body)
      Spacer()
      Image(systemName: "chevron.right")
    }
  }
}

struct SectionHeader<Content: View>: View {
  let content: () -> Content

  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }

  var body: some View {
    HStack {
      content()
        .font(.callout)
        .fontWeight(.semibold)
    }
  }
}
