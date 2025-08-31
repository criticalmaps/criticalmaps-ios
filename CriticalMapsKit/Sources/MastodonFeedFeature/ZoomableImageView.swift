import SwiftUI

struct UIKitZoomableImageView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> UIScrollView {
    let scrollView = UIScrollView()
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = 5.0
    scrollView.delegate = context.coordinator
    
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.tag = 100
    
    scrollView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
    
    // Load image asynchronously
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: url),
         let uiImage = UIImage(data: data) {
        DispatchQueue.main.async {
          imageView.image = uiImage
        }
      }
    }
    
    return scrollView
  }
  
  func updateUIView(_ uiView: UIScrollView, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }
  
  class Coordinator: NSObject, UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      scrollView.viewWithTag(100)
    }
  }
}
