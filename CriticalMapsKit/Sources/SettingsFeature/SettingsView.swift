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
  
  @Bindable var store: StoreOf<SettingsFeature>
  
  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }
  
  public var body: some View {
    SettingsForm {
      Section {
        observationModeRow
          .accessibilityValue(
            store.userSettings.isObservationModeEnabled
              ? Text(L10n.A11y.General.on)
              : Text(L10n.A11y.General.off)
          )
          .accessibilityAction {
            store.userSettings.isObservationModeEnabled.toggle()
          }
        
        Button(
          action: { store.send(.view(.privacyZonesRowTapped)) },
          label: {
            SettingsRow {
              Label {
                Text(L10n.Settings.Navigation.PrivacySettings.label)
              } icon: {
                Asset.pzLocationShield.swiftUIImage
              }

            }
          }
        )
      }
      
      Section {
        infoRow
          .accessibilityValue(
            store.userSettings.showInfoViewEnabled
              ? Text(L10n.A11y.General.on)
              : Text(L10n.A11y.General.off)
          )
          .accessibilityAction {
            store.userSettings.showInfoViewEnabled.toggle()
          }
        
        Button(
          action: { store.send(.view(.rideEventSettingsRowTapped)) },
          label: {
            SettingsRow {
              Label(L10n.Settings.eventSettings, systemImage: "calendar")
            }
          }
        )
      }
      
      Section {
        Button(
          action: { store.send(.view(.appearanceSettingsRowTapped)) },
          label: {
            SettingsRow {
              Label(L10n.Settings.Theme.appearance, systemImage: "paintpalette")
            }
          }
        )
      }

      infoSection
      
      linksSection
      
      supportSection
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
      
      appVersionAndBuildView
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    .navigationTitle(L10n.Settings.title)
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
      alignment: .topLeading
    )
    .onAppear { store.send(.view(.onAppear)) }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        CloseButton { store.send(.view(.dismiss)) }
      }
    }
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.appearanceSettings,
        action: \.destination.appearanceSettings
      ),
      destination: { store in
        AppearanceSettingsView(store: store)
      }
    )
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.privacyZonesSettings,
        action: \.destination.privacyZonesSettings
      ),
      destination: { store in
        PrivacyZoneSettingsView(store: store)
      }
    )
    .navigationDestination(
      item: $store.scope(
        state: \.destination?.rideEventSettings,
        action: \.destination.rideEventSettings
      ),
      destination: { store in
        RideEventSettingsView(store: store)
      }
    )
    .navigationDestination(isPresented: Binding($store.destination.guideFeature)) {
      GuideView()
    }
    .navigationDestination(isPresented: Binding($store.destination.acknowledgements)) {
      AcknowListSwiftUIView(acknowList: store.packageList!)
    }
  }
  
  @ViewBuilder
  var observationModeRow: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Observationmode.title)
          .font(.body)
        Text(L10n.Settings.Observationmode.detail)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
          .font(.subheadline)
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
  
  @ViewBuilder
  var infoRow: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Info.Toggle.label)
          .font(.body)
        Text(L10n.Settings.Info.Toggle.description)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
          .font(.subheadline)
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
  
  @ViewBuilder
  var supportSection: some View {
    SupportSettingsRow(
      title: L10n.Settings.programming,
      subTitle: L10n.Settings.Opensource.detail,
      link: L10n.Settings.Opensource.action,
      textStackForegroundColor: .white,
      backgroundColor: Color(UIColor.hex(0x332F38)),
      bottomImage: {
        Asset.ghLogo.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 150, height: 150, alignment: .bottomTrailing)
          .opacity(0.4)
          .accessibilityHidden(true)
      },
      action: { store.send(.view(.supportSectionRowTapped(.github))) }
    )
    .accessibilityAddTraits(.isLink)
    
    SupportSettingsRow(
      title: L10n.Settings.Translate.title,
      subTitle: L10n.Settings.Translate.subtitle,
      link: L10n.Settings.Translate.link,
      textStackForegroundColor: .white,
      backgroundColor: Color(.translateRowBackground),
      bottomImage: {
        Asset.translate.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 135, height: 135, alignment: .bottomTrailing)
          .accessibilityHidden(true)
      },
      action: { store.send(.view(.supportSectionRowTapped(.crowdin))) }
    )
    .accessibilityAddTraits(.isLink)
    
    SupportSettingsRow(
      title: L10n.Settings.CriticalMassDotIn.title,
      subTitle: L10n.Settings.CriticalMassDotIn.detail,
      link: L10n.Settings.CriticalMassDotIn.action,
      textStackForegroundColor: Color(.textPrimaryLight),
      backgroundColor: Color(.cmInRowBackground),
      bottomImage: {
        Asset.cmDotInLogo.swiftUIImage
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 160, height: 160, alignment: .bottomTrailing)
          .accessibilityHidden(true)
      },
      action: { store.send(.view(.supportSectionRowTapped(.criticalMassDotIn))) }
    )
    .accessibilityAddTraits(.isLink)
  }
  
  @ViewBuilder
  var linksSection: some View {
    Section {
      Button(
        action: { store.send(.view(.infoSectionRowTapped(.website))) },
        label: {
          SettingsInfoLink(title: L10n.Settings.website)
        }
      )
      .accessibilityAddTraits(.isLink)
      
      Button(
        action: { store.send(.view(.infoSectionRowTapped(.mastodon))) },
        label: {
          SettingsInfoLink(title: "Mastodon")
        }
      )
      .accessibilityAddTraits(.isLink)
      
      Button(
        action: { store.send(.view(.infoSectionRowTapped(.privacy))) },
        label: {
          SettingsInfoLink(title: L10n.Settings.privacyPolicy)
        }
      )
      .accessibilityAddTraits(.isLink)
      
      Button(
        action: { store.send(.view(.acknowledgementsRowTapped)) },
        label: {
          SettingsRow {
            Label(
              "Acknowledgements",
              systemImage: "text.document"
            )
          }
        }
      )
    }
  }
  
  @ViewBuilder
  var infoSection: some View {
    Section {
      Button(
        action: { store.send(.view(.guideRowTapped)) },
        label: {
          SettingsRow {
            Label(
              L10n.Rules.title,
              systemImage: "exclamationmark.bubble"
            )
          }
        }
      )
    }
  }
  
  @ViewBuilder
  var appVersionAndBuildView: some View {
    HStack(spacing: .grid(4)) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .foregroundColor(.white)
          .frame(width: 56, height: 56, alignment: .center)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(Color(.border), lineWidth: 1)
          )
        Asset.cmLogoC.swiftUIImage
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
          .foregroundStyle(colorSchemeContrast.isIncreased ? Color(.textPrimary) : Color(.textSilent))
      }
      .accessibilityElement(children: .combine)
    }
  }
}

struct SettingsInfoLink: View {
  let title: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Image(systemName: "arrow.up.right")
        .accessibilityHidden(true)
    }
    .font(.body)
  }
}

#Preview {
  NavigationStack {
    SettingsView(
      store: .init(
        initialState: .init(),
        reducer: { SettingsFeature()._printChanges() }
      )
    )
  }
}
