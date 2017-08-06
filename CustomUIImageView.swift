//
//  CustomUIImageView.swift
//  MyYouTube
//
//  Created by Elf on 15.07.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class CustomUIImageView: UIImageView {
    var imageUrl: String?
    
    func loadImageByUrlString(urlString: String) {
        imageUrl = urlString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            return
        }
        
        let imageReq = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: imageReq) {
            data, response, err in
            
            if err != nil {
                print(err!)
                return
            }
            
            DispatchQueue.global(qos: .utility).async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
                DispatchQueue.main.async {
                    if urlString == self.imageUrl {
                      self.image = imageToCache
                    }
                }
            }
            }.resume()
    }
}
