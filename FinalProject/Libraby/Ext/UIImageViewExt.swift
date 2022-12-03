//
//  UIImageViewExt.swift
//  FinalProject
//
//  Created by tu.le2 on 08/08/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(url: String) {
        guard let url = URL(string: url) else {
            self.image = nil
            return
        }
        let config = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        } else {
        }
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.image = nil
                } else {
                    if let data = data {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = nil
                    }
                }
            }
        }
        task.resume()
    }

    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(nil)
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
