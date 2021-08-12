import Helpers
import L10n
import Styleguide
import SwiftUI

public struct SettingsView: View {
  public init() {}
  
  public var body: some View {
    ScrollView {
      VStack {
        SettingsNavigationLink(
          destination: Text("Test"),
          title: L10n.Settings.eventSettings
        )
        
        SettingsRow { observationModeRow }
        
        SettingsNavigationLink(
          destination: Text("Test"),
          title: L10n.Settings.Theme.appearance
        )
        
        SettingsNavigationLink(
          destination: Text("Test"),
          title: L10n.Settings.appIcon
        )
        
        supportSection
    
        infoSection
      }
    }
    .font(.titleOne)
    .toggleStyle(SwitchToggleStyle(tint: Color(.textPrimary)))
    .navigationTitle(L10n.Settings.title)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading
    )
  }
  
  var observationModeRow: some View {
    HStack {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Observationmode.title)
          .font(.titleOne)
        Text(L10n.Settings.Observationmode.detail)
          .foregroundColor(Color(.textSilent))
          .font(.bodyOne)
      }
      Toggle(
        isOn: .constant(true),
        label: { EmptyView() }
      )
      .labelsHidden()
    }
  }
  
  var supportSection: some View {
    SettingsSection(title: "Support") { // TODO: Replace with l10n
      VStack(alignment: .leading, spacing: .grid(4)) {
        SupportSettingsRow(
          title: L10n.Settings.programming,
          subTitle: L10n.Settings.Opensource.detail,
          link: L10n.Settings.Opensource.action,
          textStackForegroundColor: Color(.textPrimary),
          backgroundColor: Color(.brand500),
          bottomImage: Image(uiImage: Images.ghIcon)
        )
        
        // TODO: Replace strings with l10n
        SupportSettingsRow(
          title: "Translate",
          subTitle: "Help making Critical Maps available in other languages",
          link: "crowdin.com",
          textStackForegroundColor: .white,
          backgroundColor: Color(.translateRowBackground),
          bottomImage: Image(uiImage: Images.translateIcon)
        )
        
        SupportSettingsRow(
          title: L10n.Settings.CriticalMassDotIn.title,
          subTitle: L10n.Settings.CriticalMassDotIn.detail,
          link: L10n.Settings.CriticalMassDotIn.action,
          textStackForegroundColor: Color(.textPrimary),
          backgroundColor: Color(.cmInRowBackground),
          bottomImage: Image(uiImage: Images.cmInIcon)
        )
      }
      .padding(.horizontal, .grid(4))
    }
  }
  
  var infoSection: some View {
    SettingsSection(title: L10n.Settings.Section.info) {
      SettingsNavigationLink(
        destination: Text("Test"),
        title: L10n.Settings.website,
        navigationType: .openURL
      )
      
      SettingsNavigationLink(
        destination: Text("Test"),
        title: L10n.Settings.twitter,
        navigationType: .openURL
      )
      
      SettingsNavigationLink(
        destination: Text("Test"),
        title: "Privacy Policy", // TODO: Replace with l10n
        navigationType: .openURL
      )
      
      HStack(spacing: .grid(4)) {
        ZStack {
          RoundedRectangle(cornerRadius: 12.5)
            .foregroundColor(.white)
            .frame(width: 56, height: 56, alignment: .center)
            .overlay(
              RoundedRectangle(cornerRadius: 12.5)
                .strokeBorder(Color(.border), lineWidth: 1)
            )
          Image(uiImage: Images.cmLogoColor)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 48, height: 48, alignment: .center)
        }
        VStack(alignment: .leading) {
          Text("Critical Maps 3.10.3")
            .font(.titleTwo)
            .foregroundColor(Color(.textPrimary))
          Text("Build 42")
            .font(.bodyTwo)
            .foregroundColor(Color(.textSilent))
        }
      }
      .padding(.vertical, .grid(4))
      .padding(.horizontal, .grid(4))
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      NavigationView {
        SettingsView()
      }
    }
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
        .padding(.vertical, .grid(4))
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
struct SettingsNavigationLink<Destination>: View where Destination: View {
  enum NavigationType {
    case openURL
    case routing
  }
  
  let destination: Destination
  let title: String
  let navigationType: NavigationType
  
  init(
    destination: Destination,
    title: String,
    navigationType: SettingsNavigationLink<Destination>.NavigationType = .routing
  ) {
    self.destination = destination
    self.title = title
    self.navigationType = navigationType
  }
  
  var body: some View {
    SettingsRow {
      if navigationType == .routing {
        NavigationLink(
          destination: self.destination,
          label: { content }
        )
      } else {
        content
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

