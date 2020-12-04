//
//  FlikerAPI.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import Foundation

struct EndPoint {
    
    static let flickrBaseURL: String = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=efb1e227a9b58dc7e39f9c8ea2ecea73"
    
    static func fillURL(lat: Double, long: Double) -> String {
        return flickrBaseURL +  "&lat=\(lat)&lon=\(long)&radius=20&format=json&nojsoncallback=1"
    }
}

//49953516761

final class FlickrAPI {
    
    static let shared = FlickrAPI()
    
    func fetchList(lat: Double, long: Double) {
        
        let urlString = EndPoint.fillURL(lat: lat, long: long)
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            guard let data = data else {
                print("didn't find any data.")
                return
            }
            
            guard let flickrResponse = try? JSONDecoder().decode(FlickrResponse.self, from: data) else {
                print("couldn't decode json")
                return
            }
            
            print(flickrResponse.photosInfo)
        }
        
        task.resume()
    }
    
}
