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
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
        case owner
        case secret
        case server
        case farm
    }
}

extension FlickrPhoto: Equatable {
    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}

struct PhotoGeoLocation: Codable {
    let photo: PhotoID
}


struct PhotoID: Codable {
    let id: String
    let location: PhotoLocation
}

struct PhotoLocation: Codable {
    let latitude: Double
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

extension PhotoLocation: Equatable {
    static func == (lhs: PhotoLocation, rhs: PhotoLocation) -> Bool {
        return  lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude
    }
}

/*
 "photos": {
         "page": 1,
         "pages": 5,
         "perpage": 250,
         "total": "1192",
         "photo": [
             {
                 "id": "50630038092",
                 "owner": "159442359@N08",
                 "secret": "8db37aca25",
                 "server": "65535",
                 "farm": 66,
                 "title": "Exterior Signage",
                 "ispublic": 1,
                 "isfriend": 0,
                 "isfamily": 0
             }
         ]
    },
    "stat": "ok"
 }
 
 */

/*
 {  "photo": {
           "id": "49953516761",
           "location": {
                     "latitude": 37.798411,      ////////////////THIS////////////////
                     "longitude": "122.436002",  ////////////////THIS////////////////
                     "accuracy": 16,
                     "context": 0,
                     "locality": {
                               "_content": "Shantung Village (historical)"
                      },
            "neighbourhood": { "_content": "" },
            "country": { "_content": "China" }
            }
    },
    "stat": "ok"
 }
 */
