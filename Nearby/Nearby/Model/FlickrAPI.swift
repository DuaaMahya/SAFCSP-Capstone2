//
//  FlikerAPI.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import Foundation

enum EndPoint: String {
    case flickrURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=fa010d860c01f7c131d13f7d71a3c326"
    
    static func fillURL(lat: Double, long: Double) -> String {
        return flickrURL.rawValue + "&user_id=&lat=\(lat)&lon=\(long)&radius=&format=json&nojsoncallback=1&api_sig=91abab52cfb70c4fa402dabd25030b3e"
    }
}

final class FlickrAPI {
    
    static let shared = FlickrAPI()
    
    func fetchList(lat: String, long: String) {
        
        let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=fa010d860c01f7c131d13f7d71a3c326&user_id=&lat=\(lat)&lon=\(long)&radius=&format=json&nojsoncallback=1&api_sig=91abab52cfb70c4fa402dabd25030b3e"
        
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
