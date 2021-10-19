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
      
      Spacer()
    }
  }
}


// AppIcon grid view
struct AppIconPicker: View {
  @Binding var appIcon: AppIcon?

  var body: some View {
    VStack(spacing: .grid(4)) {
      ForEach(Array(AppIcon.allCases.enumerated()), id: \.element) { offset, appIcon in
        SettingsRow {
          Button(action: { self.appIcon = self.appIcon == appIcon ? nil : appIcon }) {
            HStack(spacing: .grid(2)) {
              Image(uiImage: appIcon.image)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .continuousCornerRadius(12)
                .id(appIcon)

              Text(appIcon.title)

              Spacer()

              if self.appIcon == appIcon {
                Image(systemName: "checkmark")
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

// SegmentedControl like picker
struct ColorSchemePicker: View {
  @Environment(\.colorScheme) var envColorScheme
  @Binding var colorScheme: UserSettings.ColorScheme

  var body: some View {
    ZStack {
      HStack {
        if self.colorScheme != .system {
          Spacer()
            .frame(maxWidth: .infinity)
        }
        if self.colorScheme == .light {
          Spacer()
            .frame(maxWidth: .infinity)
        }
        Rectangle()
          .fill(Color(.brand500))
          .continuousCornerRadius(12)
          .frame(maxWidth: .infinity)
          .padding(4)
        if self.colorScheme == .system {
          Spacer()
            .frame(maxWidth: .infinity)
        }
        if self.colorScheme != .light {
          Spacer()
            .frame(maxWidth: .infinity)
        }
      }

      HStack {
        ForEach([UserSettings.ColorScheme.system, .dark, .light], id: \.self) { colorScheme in
          Button(
            action: {
              withAnimation(.easeOut(duration: 0.2)) {
                self.colorScheme = colorScheme
              }
            }
          ) {
            Text(colorScheme.title)
              .foregroundColor(Color.white)
              .colorMultiply(
                self.titleColor(
                  colorScheme: self.envColorScheme,
                  isSelected: self.colorScheme == colorScheme
                )
              )
              .animation(self.colorScheme == colorScheme ? .default : nil)
              .frame(maxWidth: .infinity)
              .font(.bodyOne)
          }
          .buttonStyle(PlainButtonStyle())
        }
        .padding()
      }
    }
    .background(
      Rectangle()
        .fill(Color(.border))
    )
    .continuousCornerRadius(12)
  }
  
  func titleColor(colorScheme: ColorScheme, isSelected: Bool) -> Color {
    switch colorScheme {
    case .light:
      return Color(.textPrimary)
    case .dark:
      return isSelected ? .black : .white
    @unknown default:
      return isSelected ? .white : .black
    }
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
