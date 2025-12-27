import SwiftUI

public struct ShareSheetView: UIViewControllerRepresentable {
  typealias Callback = (
    _ activityType: UIActivity.ActivityType?,
    _ completed: Bool,
    _ returnedItems: [Any]?, // swiftlint:disable:this discouraged_optional_collection
    _ error: Error?
  ) -> Void

  let activityItems: [Any]
  let applicationActivities: [UIActivity] = []
  let excludedActivityTypes: [UIActivity.ActivityType] = []
  let callback: Callback? = nil

  public init(activityItems: [Any]) {
    self.activityItems = activityItems
  }

  public func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    controller.excludedActivityTypes = excludedActivityTypes
    controller.completionWithItemsHandler = callback
    return controller
  }

  public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    // nothing to do here
  }
}
