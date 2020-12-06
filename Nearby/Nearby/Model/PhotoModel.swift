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
    
    func fetchPhotosData(lat: Double, long: Double, completion: @escaping () -> ()) {
        flickrAPI.getData(lat: lat, long: long) { [weak self] (result) in
            
            switch result {
            case .success(let photoList):
                self?.photos = photoList.photosInfo.photos
            case .failure(let error):
                print("Error Processing json data. \(error)")
            }
        }
    }
    
    func numberOfRowsInSections(section: Int) -> Int {
        if photos.count != 0 {
            return photos.count
        }
        
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> FlickrPhoto {
        return photos[indexPath.row]
    }
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        flickrAPI.getPopularMoviesData { [weak self] (result) in
            
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
    
    
}
