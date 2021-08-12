import Helpers
import L10n
import Styleguide
import SwiftUI

public struct SettingsView<Content>: View where Content: View {
  let content: () -> Content
  
  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  public var body: some View {
    ScrollView {
      self.content()
        .font(.titleOne)
        .toggleStyle(
          SwitchToggleStyle(tint: Color(.textPrimary)
          )
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      NavigationView {
        SettingsView {
          SettingsNavigationLink(
            destination: Text("Test"),
            title: L10n.Settings.eventSettings
          )
          
          HStack {
            VStack {
              Text(L10n.Settings.Observationmode.title)
                .font(.titleOne)
              Text(L10n.Settings.Observationmode.detail)
                .font(.meta)
            }
            Toggle(isOn: .constant(true), label: {
              EmptyView()
            })
          }
          
          SettingsNavigationLink(
            destination: Text("Test"),
            title: L10n.Settings.Theme.appearance
          )
          
          SettingsNavigationLink(
            destination: Text("Test"),
            title: L10n.Settings.appIcon
          )
        }
      }
    }
  }
}


// MARK: Row
public struct SettingsRow<Content>: View where Content: View {
  let content: () -> Content
  
  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      self.content()
        .padding(.vertical, .grid(4))
        .padding(.horizontal)
      seperator
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
          .padding([.bottom], .grid(4))
          .padding(.horizontal)
      }
      
      self.content()
    }
    .padding([.bottom], .grid(10))
  }
}


struct SettingsNavigationLink<Destination>: View where Destination: View {
  let destination: Destination
  let title: String
  
  var body: some View {
    SettingsRow {
      NavigationLink(
        destination: self.destination,
        label: {
          HStack {
            Text(self.title)
              .font(.titleOne)
            Spacer()
            Image(systemName: "arrow.right")
              .font(.titleOne)
          }
        }
      )
    }
  }
}

