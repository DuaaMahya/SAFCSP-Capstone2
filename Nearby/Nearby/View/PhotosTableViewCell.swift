//
//  PhotosTableViewCell.swift
//  Nearby
//
//  Created by Dua Almahyani on 06/12/2020.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var flickrPostTitleLabel: UILabel!
    @IBOutlet weak var flickrPostViewerCountLabel: UILabel!
    

    @IBOutlet weak var containerView: UIView!
    
    private var photoURLString = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupUI()
    }
    
    func setupUI() {
        flickrImageView.layer.cornerRadius = 9
        
        containerView.layer.cornerRadius = 9
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 15)
        
    }

    func setCellWithValuesOf(_ photo: FlickrPhoto) {
        updateUI(title: photo.title, farm: photo.farm, server: photo.server, id: photo.photoID, secret: photo.secret)
    }
    
    
    private func updateUI(title: String?, farm: Int?, server: String?, id: String?, secret: String?) {
        
        if title != "" {
            self.flickrPostTitleLabel.text = title
            return
        } else {
            self.flickrPostTitleLabel.text = "--"
        }
        
        self.flickrPostTitleLabel.text = title
        
        guard let farm = farm, let server = server, let id = id, let secret = secret else { return }
        
        
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
