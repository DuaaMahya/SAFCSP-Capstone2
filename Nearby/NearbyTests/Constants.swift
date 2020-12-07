//
//  Constants.swift
//  NearbyTests
//
//  Created by Dua Almahyani on 07/12/2020.
//

import Foundation

enum Constants {
    static let urlString = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=477f1f653f14a0b62f041e570b8a45e5&lat=37.7994&lon=122.3950&radius=20&format=json&nojsoncallback=1"
    
    static let id = "50630038092"
    static let title = "Exterior Signage"
    
    static let url = URL(string: urlString)!
    
    
    static let validPhotoDict: [String:Any] = [
        "id": id,
        "owner": "159442359@N08",
        "secret": "8db37aca25",
        "server": "65535",
        "farm": 66,
        "title": title,
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
    ]
    
    static let invalidPhotoDict: [String:Any] = [
        "id": "",
        "owner": "",
        "secret": "",
        "server": "",
        "farm": 0,
        "title": "",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0
    ]
    
    static let validPhotoDictionary = ["photo": [validPhotoDict] ]
    static let validPhotosDictionary = ["photos": validPhotoDictionary]
    
    static let invalidPhotoDictionary = ["photo": [invalidPhotoDict] ]
    static let invalidPhotosDictionary = ["photos": invalidPhotoDictionary]
    
    static let okResponse = HTTPURLResponse(url: url,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let notOkResponse = HTTPURLResponse(url: url,
                                            statusCode: 404,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let jsonData = try! JSONSerialization.data(withJSONObject: validPhotosDictionary)
    static let invalidJsonData = try! JSONSerialization.data(withJSONObject: invalidPhotosDictionary)
    
    static let sessionConfiguration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FakeScheduleURLProtocol.self]
        return config
    }()
    
}
    
