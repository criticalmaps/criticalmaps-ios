import SwiftUI

public enum NavPresentationStyle {
  case modal
  case navigation
}

public extension View {
  func navigationStyle(
    backgroundColor: Color = Color(.backgroundSecondary),
    foregroundColor: Color = Color(.textPrimary),
    title: some View,
    navPresentationStyle: NavPresentationStyle = .navigation,
    trailing: some View,
    onDismiss: @escaping () -> Void = {}
  ) -> some View {
    NavigationBar(
      backgroundColor: backgroundColor,
      content: self,
      foregroundColor: foregroundColor,
      navPresentationStyle: navPresentationStyle,
      onDismiss: onDismiss,
      title: title,
      trailing: trailing
    )
  }

  func navigationStyle(
    backgroundColor: Color = Color(.backgroundSecondary),
    foregroundColor: Color = Color(.textPrimary),
    title: some View,
    navPresentationStyle: NavPresentationStyle = .navigation,
    onDismiss: @escaping () -> Void = {}
  ) -> some View {
    navigationStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: title,
      navPresentationStyle: navPresentationStyle,
      trailing: EmptyView(),
      onDismiss: onDismiss
    )
  }
}

private struct NavigationBar<Title: View, Content: View, Trailing: View>: View {
  let backgroundColor: Color
  let content: Content
  let foregroundColor: Color
  let navPresentationStyle: NavPresentationStyle
  let onDismiss: () -> Void
  @Environment(\.presentationMode) @Binding var presentationMode
  let title: Title
  let trailing: Trailing

  var body: some View {
    VStack {
      ZStack {
        title
          .font(.pageTitle)
        HStack {
          if navPresentationStyle == .navigation {
            Button(action: dismiss) {
              Image(systemName: "arrow.left")
            }
          }
          Spacer()
          if navPresentationStyle == .modal {
            Button(action: dismiss) {
              Image(systemName: "xmark")
                .font(Font.system(size: 22, weight: .medium))
            }
          } else {
            trailing
          }
        }
      }
      .padding()

      content
    }
    .background(backgroundColor.ignoresSafeArea())
    .foregroundColor(foregroundColor)
    .navigationBarHidden(true)
  }

  func dismiss() {
    onDismiss()
    presentationMode.dismiss()
  }
}

public extension View {
  func dismissable() -> some View {
    modifier(DismissableModifier())
  }
}

public struct DismissableModifier: ViewModifier {
  @Environment(\.presentationMode) var presentationMode

  public func body(content: Content) -> some View {
    content
      .toolbar {
        ToolbarItem(
          placement: .topBarLeading,
          content: {
            Button(
              action: { presentationMode.wrappedValue.dismiss() },
              label: {
                Image(systemName: "xmark")
                  .font(Font.system(size: 22).weight(.medium))
              }
            )
          }
        )
      }
  }
}
