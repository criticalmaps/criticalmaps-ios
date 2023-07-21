import SwiftUI

public struct CircularProgressView: View {
  let progress: Double
  
  public init(progress: Double) {
    self.progress = progress
  }
  
  public var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color(.brand500).opacity(0.4),
          lineWidth: 8
        )
      
      Circle()
        .trim(from: progress, to: 1)
        .stroke(
          Color(.brand500),
          style: StrokeStyle(
            lineWidth: 8,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
    }
  }
}

struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    CircularProgressView(progress: 0.4)
  }
}
