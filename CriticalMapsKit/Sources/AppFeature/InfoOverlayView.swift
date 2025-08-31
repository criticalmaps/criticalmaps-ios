import ComposableArchitecture
import Helpers
import Styleguide
import SwiftUI
import SwiftUIHelpers

struct InfoOverlayView: View {
  @State private var isExpanded = false
  @State private var progress: CGFloat = 0
  
  let timerProgress: Double
  let timerValue: String
  let ridersCountLabel: String
  
  var body: some View {
    Group {
      if #available(iOS 26, *) {
        glassInfoContent()
      } else {
        ZStack(alignment: .center) {
          Blur()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .frame(
              width: isExpanded ? 120 : 50,
              height: isExpanded ? 230 : 50
            )
            .accessibleAnimation(.cmSpring.speed(1.5), value: isExpanded)
          
          infoContent()
        }
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
          .padding(4)
      },
      label: {
        progressView()
          .frame(width: 34, height: 34)
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
      collapsedOverlayView()
        .transition(
          .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0, anchor: .bottomLeading)).animation(.easeIn(duration: 0.1)),
            removal: .opacity.animation(.easeIn(duration: 0.1))
          )
        )
    }
  }
  
  @ViewBuilder
  private func expandedOverlayView() -> some View {
    VStack {
      Text("Info")
        .foregroundStyle(Color(.textPrimary))
        .font(.titleTwo)
      
      DataTile("Next update") {
        progressView()
          .frame(width: 44, height: 44)
          .padding(.top, .grid(1))
      }
      
      DataTile("Riders") {
        HStack {
          Text(ridersCountLabel)
            .font(.pageTitle)
            .modifier(NumericContentTransition())
        }
        .foregroundStyle(Color(.textPrimary))
      }
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
  
  @ViewBuilder
  private func collapsedOverlayView() -> some View {
    Button(
      action: { withAnimation(.infoOverlay) { isExpanded.toggle() } },
      label: {
        Label(
          title: { Text("Info") },
          icon: {
            Image(systemName: "info.circle")
              .resizable()
              .frame(width: 30, height: 30)
          }
        )
        .labelStyle(.iconOnly)
        .padding(2)
      }
    )
    .buttonStyle(.plain)
    .foregroundStyle(Color(.textPrimary))
  }
}

// MARK: Extensions

private extension Animation {
  static let infoOverlay: Animation = .snappy()
}
