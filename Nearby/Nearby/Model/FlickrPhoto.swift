//
//  FlickrPhoto.swift
//  Nearby
//
//  Created by Dua Almahyani on 03/12/2020.
//

import Foundation


struct FlickrResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    let photos: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

struct FlickrPhoto: Codable {
    
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}

extension FlickrPhoto: Equatable {
    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
