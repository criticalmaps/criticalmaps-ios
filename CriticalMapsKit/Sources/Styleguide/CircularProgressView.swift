import SwiftUI

public struct CircularProgressView: View {
  let progress: Double
  let lineWidth: CGFloat

  public init(
    progress: Double,
    lineWidth: CGFloat = 8
  ) {
    self.progress = progress
    self.lineWidth = lineWidth
  }

  public var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color.brand500.opacity(0.4),
          lineWidth: lineWidth
        )

      Circle()
        .trim(from: progress, to: 1)
        .stroke(
          Color.brand500,
          style: StrokeStyle(
            lineWidth: lineWidth,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .animation(.linear, value: progress)
    }
  }
}

#Preview {
  CircularProgressView(progress: 0.4)
}
