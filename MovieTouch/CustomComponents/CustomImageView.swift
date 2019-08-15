//
//  UIImageView+Extensions.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 04/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {

    var currentURLString: String = ""

    func downloadImageFrom(_ urlString: String) {
        self.currentURLString = urlString

        // Checking from cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage, self.currentURLString == urlString {
            self.add(cachedImage, animated: false)
            return
        }

        guard let url = URL(string: urlString) else {
            self.add(nil, animated: false)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let err = error {
                print("[ERROR] \(err.localizedDescription)")
                self?.add(nil)
                return
            }
            
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200, let imageData = data, let image = UIImage(data: imageData), let mimeType = resp.mimeType,  mimeType.hasPrefix("image") {
                if self?.currentURLString == urlString {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.add(image)
                }
                return
            } else {
                self?.add(nil)
                return
            }
        }
        dataTask.resume()
    }

    private func add(_ image: UIImage?, animated: Bool = true) {
        DispatchQueue.main.async {
            if animated {
                self.alpha = 0
            }
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            UIView.animate(withDuration: 1, animations: {
                if image != nil {
                    self.image = image
                } else {
                    self.image = nil
                    let label = UILabel(frame: self.bounds)
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 50)
                    label.text = "⚠️"
                    self.addSubview(label)
                }
                self.alpha = 1
            })
        }
    }
}
