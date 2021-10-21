import ComposableArchitecture
import Helpers
import L10n
import Styleguide
import SwiftUI

public struct SettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  @ObservedObject var viewStore: ViewStore<SettingsState, SettingsAction>
  
  public init(store: Store<SettingsState, SettingsAction>) {
    self.store = store
    self.viewStore = ViewStore(store, removeDuplicates: ==)
  }
  
  public var body: some View {
    SettingsForm {
      Spacer(minLength: 28)
      VStack {
        SettingsSection(title: "") {
          SettingsNavigationLink(
            destination: RideEventSettingsView(store: store),
            title: L10n.Settings.eventSettings
          )
          
          SettingsRow { observationModeRow }
          
          SettingsNavigationLink(
            destination: AppearanceSettingsView(
              store: store.scope(
                state: \SettingsState.userSettings.appearanceSettings,
                action: SettingsAction.appearance
              )
            ),
            title: L10n.Settings.Theme.appearance
          )
        }
                
        supportSection
        
        infoSection
      }
    }
    .navigationTitle(L10n.Settings.title)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading
    )
    .onAppear { viewStore.send(.onAppear) }
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
      Spacer()
      Toggle(
        isOn: viewStore.binding(
          get: { $0.userSettings.enableObservationMode },
          send: SettingsAction.setObservationMode
        ),
        label: { EmptyView() }
      )
      .labelsHidden()
    }
  }
  
  var supportSection: some View {
    SettingsSection(title: "Support") { // TODO: Replace with l10n
      VStack(alignment: .leading, spacing: .grid(4)) {
        Button(
          action: { viewStore.send(.supportSectionRowTapped(.github)) },
          label: {
            SupportSettingsRow(
              title: L10n.Settings.programming,
              subTitle: L10n.Settings.Opensource.detail,
              link: L10n.Settings.Opensource.action,
              textStackForegroundColor: Color(.textPrimaryLight),
              backgroundColor: Color(.brand500),
              bottomImage: Image(uiImage: Images.ghIcon)
            )
          }
        )
        
        // TODO: Replace strings with l10n
        Button(
          action: { viewStore.send(.supportSectionRowTapped(.crowdin)) },
          label: {
            SupportSettingsRow(
              title: "Translate",
              subTitle: "Help making Critical Maps available in other languages",
              link: "crowdin.com",
              textStackForegroundColor: .white,
              backgroundColor: Color(.translateRowBackground),
              bottomImage: Image(uiImage: Images.translateIcon)
            )
          }
        )
        
        Button(
          action: { viewStore.send(.supportSectionRowTapped(.criticalMassDotIn)) },
          label: {
            SupportSettingsRow(
              title: L10n.Settings.CriticalMassDotIn.title,
              subTitle: L10n.Settings.CriticalMassDotIn.detail,
              link: L10n.Settings.CriticalMassDotIn.action,
              textStackForegroundColor: Color(.textPrimaryLight),
              backgroundColor: Color(.cmInRowBackground),
              bottomImage: Image(uiImage: Images.cmInIcon)
            )
          }
        )
      }
      .padding(.horizontal, .grid(4))
    }
  }
  
  var infoSection: some View {
    SettingsSection(title: L10n.Settings.Section.info) {
      SettingsRow {
        Button(
          action: { viewStore.send(.infoSectionRowTapped(.website)) },
          label: {
            SettingsInfoLink(title: L10n.Settings.website)
          }
        )
      }
      
      SettingsRow {
        Button(
          action: { viewStore.send(.infoSectionRowTapped(.twitter)) },
          label: {
            SettingsInfoLink(title: L10n.Settings.twitter)
          }
        )
      }
      
      SettingsRow {
        Button(
          action: { viewStore.send(.infoSectionRowTapped(.privacy)) },
          label: {
            SettingsInfoLink(title: "Privacy Policy") // TODO: Replace with l10n
          }
        )        
      }
      
      appVersionAndBuildView
    }
  }
  
  var appVersionAndBuildView: some View {
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
        Text(viewStore.versionNumber)
          .font(.titleTwo)
          .foregroundColor(Color(.textPrimary))
        Text(viewStore.buildNumber)
          .font(.bodyTwo)
          .foregroundColor(Color(.textSilent))
      }
    }
    .padding(.grid(4))
  }
}

struct SettingsInfoLink: View {
  let title: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.titleOne)
      Spacer()
      Image(systemName: "link.circle.fill")
        .font(.titleOne)
        .accessibilityHidden(true)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      NavigationView {
        SettingsView(
          store: .init(
            initialState: .init(),
            reducer: settingsReducer,
            environment: SettingsEnvironment(
              uiApplicationClient: .noop,
              setUserInterfaceStyle: { _ in .none },
              fileClient: .noop,
              backgroundQueue: .failing,
              mainQueue: .failing
            )
          )
        )
      }
    }
  }
}
