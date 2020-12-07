//
//  PhotoModel.swift
//  Nearby
//
//  Created by Dua Almahyani on 06/12/2020.
//

import Foundation

class PhotoModel {
    
    private var flickrAPI = FlickrAPI()
    private var photos = [FlickrPhoto]()
    private var photoGeolocation = String()
    
    func numberOfRowsInSections(section: Int) -> Int {
        if photos.count != 0 {
            return photos.count
        }
        
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> FlickrPhoto {
        return photos[indexPath.row]
    }
    
    func fetchPhotosData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        flickrAPI.getFlickrData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.photos = listOf.photosInfo.photos
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
   
    func loadPhotoGeoLocationData(photoID: String, completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        flickrAPI.getGeoLocationData(photoID: photoID) { [weak self] (result) in
            
            switch result {
            case .success(let locationOf):
                self?.photoGeolocation = "\(locationOf.location.latitude)"
                completion()
            case .failure(let error):
                // Something is wrong with the JSON file or the model
                print("Error processing json data: \(error)")
            }
        }
    }
    
    
    
}
