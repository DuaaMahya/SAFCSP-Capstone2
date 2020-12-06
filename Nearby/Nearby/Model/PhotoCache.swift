//
//  PhotoCache.swift
//  Nearby
//
//  Created by Dua Almahyani on 06/12/2020.
//

import UIKit

class PhotoCache {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String){
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        
        //ZTurn image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5) {
            try? data.write(to: url)
        }
    }
    
    func fetchImage(forKey key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else { return nil }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}
