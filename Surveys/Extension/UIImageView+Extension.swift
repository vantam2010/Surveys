//
//  UIImageView+Extension.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String, resize: CGSize? = nil) {
        let url = URL(string: urlString)
        if url == nil {return}
        
        self.image = UIImage.imageWithColor(tintColor: ThemeManager.color.main)
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            if let size = resize {
                self.image = cachedImage.resizeImageUsingVImage(size: size)
            } else {
                self.image = cachedImage
            }
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    if let size = resize {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image.resizeImageUsingVImage(size: size)
                    } else {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
            }
            
        }).resume()
    }
}
