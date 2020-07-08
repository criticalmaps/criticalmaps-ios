//
// Created for CriticalMaps in 2020

import UIKit

protocol ImageUploading {
    func uploadImage(image: UIImage)
}

final class ImageUploader: ImageUploading {
    func uploadImage(image: UIImage) {
        //        loadingView.start()
        getBase64Image(image: image) { base64Image in
            guard let request = try? ImageUploadRequest(base64Image: base64Image).makeRequest() else {
                Logger.log(.debug, log: .default, "Unable to build image upload request")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("failed with error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200 ... 299).contains(response.statusCode) else {
                    print("server error")
                    return
                }
                if let mimeType = response.mimeType, mimeType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("upload results: \(dataString)")

                    let parsedResult: [String: AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        if let dataJson = parsedResult["data"] as? [String: Any] {
                            print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
                            DispatchQueue.main.async {
                                //                                self.performSegue(withIdentifier: "detailsseg", sender: self)
                            }
                        }
                    } catch {
                        // Display an error
                    }
                }
            }.resume()
        }
    }

    private func getBase64Image(image: UIImage, complete: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            let imageData = image.pngData()
            let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
            complete(base64Image)
        }
    }
}
