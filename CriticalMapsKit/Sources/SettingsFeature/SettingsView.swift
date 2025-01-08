import AcknowList
import ComposableArchitecture
import GuideFeature
import Helpers
import L10n
import Styleguide
import SwiftUI
import SwiftUIHelpers

/// A view to render the app settings.
public struct SettingsView: View {
  @Environment(\.colorSchemeContrast) var colorSchemeContrast
  
  @State var store: StoreOf<SettingsFeature>
  
  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    SettingsForm {
      Spacer(minLength: 28)
      VStack {
        SettingsRow {
          observationModeRow
            .accessibilityValue(
              store.userSettings.isObservationModeEnabled
                ? Text(L10n.A11y.General.on)
                : Text(L10n.A11y.General.off)
            )
            .accessibilityAction {
              store.send(
                .binding(
                  .set(
                    \.userSettings.isObservationModeEnabled,
                     !store.userSettings.isObservationModeEnabled
                  )
                )
              )
            }
        }
        
        SettingsRow {
          infoRow
            .accessibilityValue(
              store.userSettings.showInfoViewEnabled
                ? Text(L10n.A11y.General.on)
                : Text(L10n.A11y.General.off)
            )
            .accessibilityAction {
              store.send(
                .binding(
                  .set(
                    \.userSettings.showInfoViewEnabled,
                     !store.userSettings.showInfoViewEnabled
                  )
                )
              )
            }
        }
        
        SettingsSection(title: "") {
          SettingsRow {
            Button(
              action: { store.send(.rideEventSettingsRowTapped) },
              label: {
                HStack {
                  Text(L10n.Settings.eventSettings) }
                  Spacer()
                  Image(systemName: "chevron.right")
                }
            )
          }
          
          SettingsRow {
            Button(
              action: { store.send(.appearanceSettingsRowTapped) },
              label: {
                HStack {
                  Text(L10n.Settings.Theme.appearance)
                  Spacer()
                  Image(systemName: "chevron.right")
                }
              }
            )
          }
        }
                
        supportSection
        
        infoSection
        
        linksSection
        
        HStack {
          appVersionAndBuildView
          Spacer()
        }
      }
    }
    .navigationTitle(L10n.Settings.title)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading
    )
    .onAppear { store.send(.onAppear) }
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.appearance,
        action: \.destination.appearance
      ),
      destination: { store in
        AppearanceSettingsView(store: store)
      }
    )
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.rideEvents,
        action: \.destination.rideEvents
      ),
      destination: { store in
        RideEventSettingsView(store: store)
      }
    )
  }
  
  var observationModeRow: some View {
    HStack {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Observationmode.title)
          .font(.titleOne)
        Text(L10n.Settings.Observationmode.detail)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
          .font(.bodyOne)
      }
      Spacer()
      Toggle(
        isOn: $store.userSettings.isObservationModeEnabled,
        label: { EmptyView() }
      )
      .labelsHidden()
    }
    .accessibilityElement(children: .combine)
  }
  
  var infoRow: some View {
    HStack {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text("Show info view")
          .font(.titleOne)
        Text("Show info toogle over the map")
          .foregroundColor(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
          .font(.bodyOne)
      }
      Spacer()
      Toggle(
        isOn: $store.userSettings.showInfoViewEnabled,
        label: { EmptyView() }
      )
      .labelsHidden()
    }
    .accessibilityElement(children: .combine)
  }
  
  var supportSection: some View {
    SettingsSection(title: L10n.Settings.support) {
      VStack(alignment: .leading, spacing: .grid(4)) {
        SupportSettingsRow(
          title: L10n.Settings.programming,
          subTitle: L10n.Settings.Opensource.detail,
          link: L10n.Settings.Opensource.action,
          textStackForegroundColor: .white,
          backgroundColor: Color(UIColor.hex(0x332F38)),
          bottomImage: {
            Image(uiImage: Asset.ghLogo.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 150, height: 150, alignment: .bottomTrailing)
              .opacity(0.4)
              .accessibilityHidden(true)
          },
          action: { store.send(.supportSectionRowTapped(.github)) }
        )
        .accessibilityAddTraits(.isLink)
        
        SupportSettingsRow(
          title: L10n.Settings.Translate.title,
          subTitle: L10n.Settings.Translate.subtitle,
          link: L10n.Settings.Translate.link,
          textStackForegroundColor: .white,
          backgroundColor: Color(.translateRowBackground),
          bottomImage: {
            Image(uiImage: Asset.translate.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 135, height: 135, alignment: .bottomTrailing)
              .accessibilityHidden(true)
          },
          action: { store.send(.supportSectionRowTapped(.crowdin)) }
        )
        .accessibilityAddTraits(.isLink)
        
        SupportSettingsRow(
          title: L10n.Settings.CriticalMassDotIn.title,
          subTitle: L10n.Settings.CriticalMassDotIn.detail,
          link: L10n.Settings.CriticalMassDotIn.action,
          textStackForegroundColor: Color(.textPrimaryLight),
          backgroundColor: Color(.cmInRowBackground),
          bottomImage: {
            Image(uiImage: Asset.cmDotInLogo.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 160, height: 160, alignment: .bottomTrailing)
              .accessibilityHidden(true)
          },
          action: { store.send(.supportSectionRowTapped(.criticalMassDotIn)) }
        )
        .accessibilityAddTraits(.isLink)
      }
      .padding(.horizontal, .grid(4))
    }
  }
  
  @ViewBuilder
  var linksSection: some View {
    SettingsSection(title: "Links") {
      SettingsRow {
        Button(
          action: { store.send(.infoSectionRowTapped(.website)) },
          label: {
            SettingsInfoLink(title: L10n.Settings.website)
          }
        )
        .accessibilityAddTraits(.isLink)
      }
      
      SettingsRow {
        Button(
          action: { store.send(.infoSectionRowTapped(.mastodon)) },
          label: {
            SettingsInfoLink(title: "Mastodon")
          }
        )
        .accessibilityAddTraits(.isLink)
      }
      
      SettingsRow {
        Button(
          action: { store.send(.infoSectionRowTapped(.privacy)) },
          label: {
            SettingsInfoLink(title: L10n.Settings.privacyPolicy)
          }
        )
        .accessibilityAddTraits(.isLink)
      }
    }
  }
  
  @ViewBuilder
  var infoSection: some View {
    SettingsSection(title: L10n.Settings.Section.info) {
      SettingsNavigationLink(
        destination: { GuideView() },
        title: {
          HStack(spacing: .grid(2)) {
            Text(L10n.Rules.title)
            Image(systemName: "exclamationmark.bubble")
          }
        }
      )
      
      if let licenses = store.packageList {
        SettingsNavigationLink(
          destination: {
            AcknowListSwiftUIView(acknowList: licenses)
          },
          title: { Text("Acknowledgements") }
        )
      }
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
        Image(uiImage: Asset.cmLogoC.image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 48, height: 48, alignment: .center)
      }
      .accessibilityHidden(true)
      
      VStack(alignment: .leading) {
        Text("Critical Maps")
          .font(.titleTwo)
          .foregroundColor(Color(.textPrimary))
        Text("Version: \(store.versionNumber)+\(store.buildNumber)")
          .font(.bodyTwo)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
      }
      .accessibilityElement(children: .combine)
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
      Image(systemName: "arrow.up.right")
        .font(.titleOne)
        .accessibilityHidden(true)
    }
  }
}

#Preview {
  NavigationStack {
    SettingsView(
      store: .init(
        initialState: .init(),
        reducer: { SettingsFeature() }
      )
    )
  }
}
