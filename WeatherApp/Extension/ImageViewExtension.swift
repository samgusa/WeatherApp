//
//  ImageViewExtension.swift
//  WeatherApp
//
//  Created by Sam Greenhill on 6/12/20.
//  Copyright © 2020 simplyAmazingMachines. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

let cachedImages = NSCache<NSString, UIImage>()

extension UIImageView {
    //allows iamges loaded from web to be cached. for smooth loading, doesn't use cellular data
    func loadImageFromURL(url: String) {
        self.image = nil
        guard let URL = URL(string: url) else {
            print("No image for this url", url)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL) {
                if let image = UIImage(data: data) {
                    let imageToCache = image
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    
                    DispatchQueue.main.async {
                        self?.image = imageToCache
                    }
                }
            }
        }
    }
    
    //Fetch image profile from url using URLSession and DispatchQueue main Async
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        //check cache for image first
        if let cacheImage = cachedImages.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        
        //Otherwise fire off a new download
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    cachedImages.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                    
                }
            }
            
        })
        task.resume()
    }

}
