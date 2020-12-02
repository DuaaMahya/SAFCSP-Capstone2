//
//  FlikerAPI.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import Foundation

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

class FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a996bd52a219a6eadaab624e2abd78b7"
    
    private var latitude: Double!
    private var longitude: Double!
    
}
