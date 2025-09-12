import ComposableArchitecture
import Helpers
import L10n
import SettingsFeature
import Styleguide
import SwiftUI
import SwiftUIHelpers

struct InfoOverlayView: View {
  @State private var isExpanded = false
  @State private var progress: CGFloat = 0
  
  let timerProgress: Double
  let timerValue: String
  let ridersCountLabel: String
  let isInPrivacyZone: Bool
  
  var body: some View {
    Group {
      if #available(iOS 26, *) {
        glassInfoContent()
      } else {
        infoContent()
          .padding(.grid(2))
          .background(
            .regularMaterial,
            in: RoundedRectangle(cornerRadius: .grid(isExpanded ? 3 : 20), style: .continuous)
          )
          .accessibleAnimation(.snappy(duration: 0.3), value: isExpanded)
      }
    }
  }
  
  @available(iOS 26, *)
  @ViewBuilder
  private func glassInfoContent() -> some View {
    ExpandableGlassMenu(
      alignment: .topLeading,
      progress: progress,
      content: {
        expandedOverlayView()
          .padding(.grid(2))
      },
      label: {
        progressView()
          .frame(width: 36, height: 36)
          .padding(.grid(1))
          .onTapGesture {
            withAnimation(.infoOverlay) { isExpanded.toggle() }
          }
      }
    )
    .onChange(of: isExpanded) { _, newValue in
      withAnimation(.infoOverlay) {
        progress = newValue ? 1 : 0
      }
    }
  }
  
  @ViewBuilder
  private func infoContent() -> some View {
    if isExpanded {
      expandedOverlayView()
        .transition(
          .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 1, anchor: .topLeading)).animation(.easeIn(duration: 0.2)),
            removal: .opacity.combined(with: .scale(scale: 0, anchor: .topLeading)).animation(.easeIn(duration: 0.12))
          )
        )
    } else {
      progressView()
        .frame(width: 36, height: 36)
        .padding(.grid(1))
        .transition(
          .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0, anchor: .bottomLeading)).animation(.easeIn(duration: 0.1)),
            removal: .opacity.animation(.easeIn(duration: 0.1))
          )
        )
        .onTapGesture {
          withAnimation(.infoOverlay) { isExpanded.toggle() }
        }
    }
  }
  
  @ViewBuilder
  private func expandedOverlayView() -> some View {
    VStack {
      DataTile(L10n.AppView.Overlay.nextUpdate) {
        progressView()
          .frame(width: 44, height: 44)
          .padding(.top, .grid(1))
      }
      
      DataTile(L10n.AppView.Overlay.riders) {
        HStack {
          Text(ridersCountLabel)
            .font(.pageTitle)
            .modifier(NumericContentTransition())
        }
        .foregroundStyle(Color(.textPrimary))
      }
      
      PrivacyStatusTile(isInPrivacyZone: isInPrivacyZone)
    }
    .contentShape(Rectangle())
    .adaptiveClipShape()
    .onTapGesture {
      withAnimation(.infoOverlay) { isExpanded.toggle() }
    }
  }
  
  @ViewBuilder
  private func progressView() -> some View {
    CircularProgressView(progress: timerProgress)
      .overlay(alignment: .center) {
        Text(verbatim: timerValue)
          .foregroundStyle(Color(.textPrimary))
          .font(.system(size: 14).bold())
          .monospacedDigit()
          .modifier(NumericContentTransition())
      }
  }
}

// MARK: Extensions

private extension Animation {
  static let infoOverlay: Animation = .snappy()
}
