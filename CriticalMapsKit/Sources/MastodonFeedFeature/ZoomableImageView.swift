import SwiftUI

struct UIKitZoomableImageView: UIViewControllerRepresentable {
  let items: [ImageSheetItem]
  let startIndex: Int
  
  init(items: [ImageSheetItem], startIndex: Int = 0) {
    self.items = items
    self.startIndex = max(0, min(startIndex, items.count - 1))
  }
  
  func makeUIViewController(context: Context) -> PagedZoomController {
    let controller = PagedZoomController(items: items, startIndex: startIndex)
    controller.dataSource = context.coordinator
    controller.delegate = context.coordinator
    context.coordinator.host = controller
    return controller
  }
  
  func updateUIViewController(_ uiViewController: PagedZoomController, context: Context) {
    // No-op: content is static for the life of the sheet
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(items: items)
  }
  
  // MARK: - Coordinator
  
  final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let items: [ImageSheetItem]
    weak var host: PagedZoomController?
    
    init(items: [ImageSheetItem]) {
      self.items = items
    }
    
    func makePage(for index: Int) -> ZoomPageViewController? {
      guard items.indices.contains(index) else { return nil }
      return ZoomPageViewController(item: items[index], index: index)
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore fromVC: UIViewController
    ) -> UIViewController? {
      guard let vc = fromVC as? ZoomPageViewController else { return nil }
      return makePage(for: vc.index - 1)
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter fromVC: UIViewController
    ) -> UIViewController? {
      guard let vc = fromVC as? ZoomPageViewController else { return nil }
      return makePage(for: vc.index + 1)
    }
    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool
    ) {
      guard
        completed,
        let current = pageViewController.viewControllers?.first as? ZoomPageViewController
      else { return }
      host?.setCurrentPage(current.index)
    }
  }
}

// MARK: - Paged container

final class PagedZoomController: UIPageViewController {
  private let items: [ImageSheetItem]
  private(set) var currentIndex: Int
  private let pageControl = UIPageControl()
  
  init(items: [ImageSheetItem], startIndex: Int) {
    self.items = items
    currentIndex = startIndex
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    // UIPageControl setup
    pageControl.numberOfPages = items.count
    pageControl.currentPage = startIndex
    pageControl.currentPageIndicatorTintColor = .white
    pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pageControl)
    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
    ])
    
    // Start with the initial page
    if let initial = ZoomPageViewController(item: items[startIndex], index: startIndex) {
      setViewControllers([initial], direction: .forward, animated: false, completion: nil)
    }
    
    // Improve background for dark sheet
    view.backgroundColor = .clear
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setCurrentPage(_ index: Int) {
    currentIndex = index
    pageControl.currentPage = index
  }
}

// MARK: - Per-page zoomable controller

final class ZoomPageViewController: UIViewController, UIScrollViewDelegate {
  let item: ImageSheetItem
  let index: Int
  
  private let scrollView = UIScrollView()
  private let imageView = UIImageView()
  private let activity = UIActivityIndicatorView(style: .large)
  
  init?(item: ImageSheetItem, index: Int) {
    self.item = item
    self.index = index
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    
    // ScrollView setup
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 5.0
    scrollView.delegate = self
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    // ImageView setup
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.isAccessibilityElement = item.description != nil
    imageView.accessibilityLabel = item.description ?? ""
    imageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
    ])
    
    // Activity indicator
    activity.translatesAutoresizingMaskIntoConstraints = false
    activity.hidesWhenStopped = true
    view.addSubview(activity)
    NSLayoutConstraint.activate([
      activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    activity.startAnimating()
    
    loadImage()
    
    // Double-tap to zoom toggle
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
    doubleTap.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTap)
  }
  
  private func loadImage() {
    let url = item.url
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self else { return }
      if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.activity.stopAnimating()
          self.imageView.image = image
        }
      } else {
        DispatchQueue.main.async {
          self.activity.stopAnimating()
          // Optional: show a placeholder or error indicator
        }
      }
    }
  }
  
  // MARK: UIScrollViewDelegate
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
  
  // MARK: Double tap
  
  @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
    let newScale: CGFloat = scrollView.zoomScale > 1.0 ? 1.0 : min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
    let pointInView = gesture.location(in: imageView)
    zoom(to: pointInView, scale: newScale, animated: true)
  }
  
  private func zoom(to point: CGPoint, scale: CGFloat, animated: Bool) {
    let scrollViewSize = scrollView.bounds.size
    
    let width = scrollViewSize.width / scale
    let height = scrollViewSize.height / scale
    let x = point.x - (width / 2.0)
    let y = point.y - (height / 2.0)
    
    let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
    scrollView.zoom(to: rectToZoomTo, animated: animated)
  }
}
