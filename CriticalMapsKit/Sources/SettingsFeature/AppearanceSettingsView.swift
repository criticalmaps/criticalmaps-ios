import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct AppearanceSettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  @ObservedObject var viewStore: ViewStore<SettingsState, SettingsAction>
  
  public init(store: Store<SettingsState, SettingsAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    SettingsForm {
      SettingsSection(title: "Theme") {
        Picker(
          "",
          selection: self.viewStore.binding(
            get: \.userSettings.colorScheme,
            send: SettingsAction.setColorScheme
          )
        ) {
          ForEach(UserSettings.ColorScheme.allCases, id: \.self) {
            Text($0.title)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(height: 50)
        .padding(.horizontal, .grid(4))
        
        SettingsSection(title: L10n.Settings.appIcon) {
          AppIconPicker(
            appIcon: viewStore.binding(
              get: \.userSettings.appIcon,
              send: SettingsAction.setAppIcon
            )
          )
        }
      }
    }
    .navigationBarTitle(L10n.Settings.Theme.appearance, displayMode: .inline)
  }
}


// AppIcon grid view
struct AppIconPicker: View {
  @Binding var appIcon: AppIcon?

  var body: some View {
    VStack(spacing: .grid(2)) {
      ForEach(Array(AppIcon.allCases.enumerated()), id: \.element) { offset, appIcon in
        SettingsRow {
          Button(action: { self.appIcon = self.appIcon == appIcon ? nil : appIcon }) {
            HStack(spacing: .grid(3)) {
              Image(uiImage: appIcon.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .continuousCornerRadius(12)
                .id(appIcon)
                .overlay(
                  RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.textPrimary), lineWidth: 0.4)
                )

              Text(appIcon.title)

              Spacer()

              if self.appIcon == appIcon {
                Image(systemName: "checkmark.circle.fill")
              }
            }
          }
        }
      }
    }
  }
}

extension View {
  public func applying<V: View>(@ViewBuilder _ builder: @escaping (Self) -> V) -> some View {
    builder(self)
  }
}

extension UserSettings.ColorScheme {
  var title: String {
    switch self {
    case .system:
      return L10n.Settings.Theme.system
    case .light:
      return L10n.Settings.Theme.light
    case .dark:
      return L10n.Settings.Theme.dark
    }
  }
}

extension View {
  public func continuousCornerRadius(_ radius: CGFloat) -> some View {
    self
      .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
  }
}

extension AppIcon {
  var image: UIImage {
    UIImage(named: self.rawValue, in: .module, with: nil)!
  }
  
  var title: String {
    switch self {
    case .appIcon1:
      return "Dark"
    case .appIcon2:
      return "Light"
    case .appIcon3:
      return "Neon"
    case .appIcon4:
      return "Rainbow"
    case .appIcon5:
      return "Yellow"
    }
  }
}
