//
//  NearbyTests.swift
//  NearbyTests
//
//  Created by Dua Almahyani on 01/12/2020.
//

import XCTest
@testable import Nearby

class NearbyTests: XCTestCase {
    
    var fetcher: FlickrAPI!

    override func setUp() {
        super.setUp()
        
        fetcher = FlickrAPI(configuration: Constants.sessionConfiguration)
    }
    
    func testResultFromValidHTTPResponseAndValidData() {
        fetcher.handler(data: Constants.jsonData,
                                     response: Constants.okResponse,
                                     error: nil) { (result) in
            switch result {
            case .success(let response):
                XCTAssert(response.photosInfo.photos.count == 1)
                let thePhoto = response.photosInfo.photos[0]
                XCTAssertEqual(thePhoto.photoID, Constants.id)
                XCTAssertEqual(thePhoto.title, Constants.title)
            default:
                XCTFail("Result contains Failure, but Success was expected.")
            }
        }
    }
    
    func testResultFromInvalidHTTPResponseAndValidData() {
        fetcher.handler(data: Constants.invalidJsonData,
                        response: Constants.okResponse,
                        error: nil) { (result) in
            
            switch result {
            case .failure(let error):
                XCTFail("Result contains Failure\(error.localizedDescription)")
            default:
                break
            }
        }
    }
    
    func testResultFromInvalidHTTPResponseAndInvalidData() {
        fetcher.handler(data: Constants.invalidJsonData,
                        response: Constants.notOkResponse,
                        error: nil) { (result) in
            
            switch result {
            case .failure(let error):
                XCTFail("Result contains Failure\(error.localizedDescription)")
            default:
                break
            }
        }
    }
    
    func testResultFromValidHTTPResponseAndNillData() {
        fetcher.handler(data: nil,
                        response: Constants.okResponse,
                        error: nil) { (result) in
            
            switch result {
            case .failure(let error):
                XCTFail("Result contains Failure\(error.localizedDescription)")
            default:
                break
            }
        }
    }

}
