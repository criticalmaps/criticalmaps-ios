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
        ObservationModeRow(store: store)

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
        InfoRow(store: store)

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

      InfoSection(store: store)

      LinksSection(store: store)

      SupportSection(store: store)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)

      AppVersionView(store: store)
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
    .navigationDestination(isPresented: $store.destination.guideFeature) {
      GuideView()
    }
    .navigationDestination(isPresented: $store.destination.acknowledgements) {
      AcknowListSwiftUIView(acknowList: store.packageList!)
    }
  }
}

// MARK: - Subviews

private struct ObservationModeRow: View {
  @Environment(\.colorSchemeContrast) private var colorSchemeContrast
  @Bindable var store: StoreOf<SettingsFeature>

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Observationmode.title)
          .font(.body)
        Text(L10n.Settings.Observationmode.detail)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color.textPrimary : Color.textSilent)
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
    .accessibilityValue(
      store.userSettings.isObservationModeEnabled
        ? Text(L10n.A11y.General.on)
        : Text(L10n.A11y.General.off)
    )
    .accessibilityAction {
      store.userSettings.isObservationModeEnabled.toggle()
    }
  }
}

private struct InfoRow: View {
  @Environment(\.colorSchemeContrast) private var colorSchemeContrast
  @Bindable var store: StoreOf<SettingsFeature>

  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(L10n.Settings.Info.Toggle.label)
          .font(.body)
        Text(L10n.Settings.Info.Toggle.description)
          .foregroundColor(colorSchemeContrast.isIncreased ? Color.textPrimary : Color.textSilent)
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
    .accessibilityValue(
      store.userSettings.showInfoViewEnabled
        ? Text(L10n.A11y.General.on)
        : Text(L10n.A11y.General.off)
    )
    .accessibilityAction {
      store.userSettings.showInfoViewEnabled.toggle()
    }
  }
}

private struct SupportSection: View {
  let store: StoreOf<SettingsFeature>

  var body: some View {
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
      backgroundColor: .translateRowBackground,
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
      textStackForegroundColor: .textPrimaryLight,
      backgroundColor: .cmInRowBackground,
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
}

private struct LinksSection: View {
  let store: StoreOf<SettingsFeature>

  var body: some View {
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
}

private struct InfoSection: View {
  let store: StoreOf<SettingsFeature>

  var body: some View {
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
}

private struct AppVersionView: View {
  @Environment(\.colorSchemeContrast) private var colorSchemeContrast
  let store: StoreOf<SettingsFeature>

  var body: some View {
    HStack(spacing: .grid(4)) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .foregroundColor(.white)
          .frame(width: 56, height: 56, alignment: .center)
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(Color.border, lineWidth: 1)
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
          .foregroundColor(.textPrimary)
        Text("Version: \(store.versionNumber)+\(store.buildNumber)")
          .font(.bodyTwo)
          .foregroundStyle(colorSchemeContrast.isIncreased ? Color.textPrimary : Color.textSilent)
      }
      .accessibilityElement(children: .combine)
    }
  }
}

private struct SettingsInfoLink: View {
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

// MARK: - Preview

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
