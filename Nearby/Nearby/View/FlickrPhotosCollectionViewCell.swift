//
//  FlickrPhotosCollectionViewCell.swift
//  Nearby
//
//  Created by Dua Almahyani on 02/12/2020.
//

import UIKit

class FlickrPhotosCollectionViewCell: UICollectionViewCell {
    
 
    @IBOutlet weak var flickrPostDistanceLabel: UILabel!
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var flickrPostTitleLabel: UILabel!
    @IBOutlet weak var flickrPostViewerCountLabel: UILabel!
    
    private var photoURLString = ""
    
    func setCellWithValuesOf(_ photo: FlickrPhoto) {
        updateUI(title: photo.title, farm: photo.farm, server: photo.server, id: photo.photoID, secret: photo.secret)
    }
    
    
    private func updateUI(title: String?, farm: Int?, server: String?, id: String?, secret: String?) {
        
        guard let title = title, let farm = farm, let server = server, let id = id, let secret = secret else { return }
        
        self.flickrPostTitleLabel.text = title
        
        photoURLString = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
        
        guard let photoURL = URL(string: photoURLString) else {
            self.flickrImageView.image = UIImage(named: "gray")
            return
        }
        
        // clear photo first
        self.flickrPostTitleLabel.text = "--"
        self.flickrImageView.image = nil
        
        fetchImageData(from: photoURL)
        
    }
    
    
    private func fetchImageData(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            
            if let error = error {
                print("Data task error. \(error)")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.flickrImageView.image = image
                }
            }
            
        }.resume()
    }
}
