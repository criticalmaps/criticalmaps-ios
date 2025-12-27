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

  let cycleStartTime: Date?
  let ridersCountLabel: String
  let isInPrivacyZone: Bool

  var body: some View {
    Group {
      if #available(iOS 26, *) {
        InfoOverlayGlassContent(
          isExpanded: $isExpanded,
          progress: $progress,
          cycleStartTime: cycleStartTime,
          ridersCountLabel: ridersCountLabel,
          isInPrivacyZone: isInPrivacyZone
        )
      } else {
        InfoOverlayLegacyContent(
          isExpanded: $isExpanded,
          cycleStartTime: cycleStartTime,
          ridersCountLabel: ridersCountLabel,
          isInPrivacyZone: isInPrivacyZone
        )
        .padding(.grid(2))
        .background(
          .regularMaterial,
          in: RoundedRectangle(cornerRadius: .grid(isExpanded ? 3 : 20), style: .continuous)
        )
        .accessibleAnimation(.snappy(duration: 0.3), value: isExpanded)
      }
    }
  }
}

// MARK: - iOS 26+ Glass Style

@available(iOS 26, *)
private struct InfoOverlayGlassContent: View {
  @Binding var isExpanded: Bool
  @Binding var progress: CGFloat

  let cycleStartTime: Date?
  let ridersCountLabel: String
  let isInPrivacyZone: Bool

  var body: some View {
    ExpandableGlassMenu(
      alignment: .topLeading,
      progress: progress,
      content: {
        InfoOverlayExpandedContent(
          isExpanded: $isExpanded,
          cycleStartTime: cycleStartTime,
          ridersCountLabel: ridersCountLabel,
          isInPrivacyZone: isInPrivacyZone
        )
        .padding(.grid(2))
      },
      label: {
        InfoOverlayTimerView(cycleStartTime: cycleStartTime, lineWidth: 5)
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
}

// MARK: - Legacy (iOS <26) Style

private struct InfoOverlayLegacyContent: View {
  @Binding var isExpanded: Bool

  let cycleStartTime: Date?
  let ridersCountLabel: String
  let isInPrivacyZone: Bool

  var body: some View {
    if isExpanded {
      InfoOverlayExpandedContent(
        isExpanded: $isExpanded,
        cycleStartTime: cycleStartTime,
        ridersCountLabel: ridersCountLabel,
        isInPrivacyZone: isInPrivacyZone
      )
      .transition(
        .asymmetric(
          insertion: .opacity.combined(with: .scale(scale: 1, anchor: .topLeading)).animation(.easeIn(duration: 0.2)),
          removal: .opacity.combined(with: .scale(scale: 0, anchor: .topLeading)).animation(.easeIn(duration: 0.12))
        )
      )
    } else {
      InfoOverlayTimerView(cycleStartTime: cycleStartTime, lineWidth: 8)
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
}

// MARK: - Expanded Content

private struct InfoOverlayExpandedContent: View {
  @Binding var isExpanded: Bool

  let cycleStartTime: Date?
  let ridersCountLabel: String
  let isInPrivacyZone: Bool

  var body: some View {
    VStack {
      DataTile(L10n.AppView.Overlay.nextUpdate) {
        InfoOverlayTimerView(cycleStartTime: cycleStartTime, lineWidth: 8)
          .frame(width: 44, height: 44)
          .padding(.top, .grid(1))
      }

      DataTile(L10n.AppView.Overlay.riders) {
        HStack {
          Text(ridersCountLabel)
            .font(.pageTitle)
            .contentTransition(.numericText(countsDown: true))
        }
        .foregroundStyle(Color.textPrimary)
      }

      PrivacyStatusTile(isInPrivacyZone: isInPrivacyZone)
    }
    .contentShape(.rect)
    .adaptiveClipShape()
    .onTapGesture {
      withAnimation(.infoOverlay) { isExpanded.toggle() }
    }
  }
}

// MARK: - Timer Progress View

/// Displays a circular progress indicator with countdown timer.
/// Uses TimelineView to update every second without triggering parent re-renders.
private struct InfoOverlayTimerView: View {
  let cycleStartTime: Date?
  let lineWidth: CGFloat

  private let cycleDuration: TimeInterval = 60

  var body: some View {
    // TimelineView updates independently - parent doesn't re-render
    TimelineView(.periodic(from: .now, by: 1.0)) { context in
      let (progress, secondsRemaining) = calculateProgress(at: context.date)

      CircularProgressView(progress: progress, lineWidth: lineWidth)
        .overlay(alignment: .center) {
          Text(verbatim: "\(secondsRemaining)")
            .foregroundStyle(Color.textPrimary)
            .font(.system(size: 14).bold())
            .monospacedDigit()
            .contentTransition(.numericText(countsDown: true))
        }
    }
  }

  /// Calculate progress and remaining seconds based on cycle start time
  private func calculateProgress(at currentTime: Date) -> (progress: Double, secondsRemaining: Int) {
    guard let startTime = cycleStartTime else {
      return (0, 60)
    }

    let elapsed = currentTime.timeIntervalSince(startTime)
    let progress = min(elapsed / cycleDuration, 1.0)
    let remaining = max(0, Int(cycleDuration - elapsed))

    return (progress, remaining)
  }
}

// MARK: Extensions

private extension Animation {
  static let infoOverlay: Animation = .snappy()
}
