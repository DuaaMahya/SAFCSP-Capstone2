//
//  FlikerAPI.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import UIKit

struct EndPoint {
    
    static let flickrBaseURL: String = "https://www.flickr.com/services/rest"
    
    static let photoSearch: String = "flickr.photos.search"
    
    static let geoLocation: String = "flickr.photos.geo.getLocation"
    
    static let apiKey: String = "477f1f653f14a0b62f041e570b8a45e5"
    
    static func fillURL(lat: Double, long: Double) -> String {
        return flickrBaseURL + "/?method=" + photoSearch + "&api_key=" + apiKey + "&lat=\(lat)&lon=\(long)&radius=20&format=json&nojsoncallback=1"
    }
    
    static func geoLocationURL(photoID: String) -> String {
        return flickrBaseURL + "/?method=" + geoLocation + "&api_key=" + apiKey + "&photo_id=\(photoID)&format=json&nojsoncallback=1"
    }
}

final class FlickrAPI {
    
    static let shared = FlickrAPI()
    private var dataTask: URLSessionDataTask?
    var locations = MapViewController()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    //MARK: - Cache Image
    func storeImage(urlString: String, image: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = image.jpegData(compressionQuality: 0.5)
        
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String]
        if dict == nil {
            dict = [String:String]()
        }
        
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }
    
    
    func getFlickrData(completion: @escaping (Result<FlickrResponse, Error>) -> Void) {
        
        let urlString = EndPoint.fillURL(lat: locations.latitude, long: locations.longitude)
        
        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String] {
            if let path = dict[urlString] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    do {
                        // Parse the data
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(FlickrResponse.self, from: data)
                        if let image = UIImage(data: data) {
                            self.storeImage(urlString: urlString, image: image)
                        }
                        completion(.success(jsonData))
                        return
                        
                    } catch let error {
                        completion(.failure(error))
                        return
                    }
                }
            }
        }
        
        
        guard let url = URL(string: urlString) else {return}
        
        // Create URL Session - work on the background
        dataTask = session.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            self.handler(data: data, response: response, error: error) { (result) in
                completion(result)
            }
            
        }
        dataTask?.resume()
    }
    
    
    func getGeoLocationData(photoID: String, completion: @escaping (Result<PhotoID,Error>) -> Void) {
        
        if let url = URL(string: EndPoint.geoLocationURL(photoID: "")) {
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            // 3.Give a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Data task error. \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Empty Response.")
                    return
                }
                
                print("response status code:\(response.statusCode)")
                
                guard let data = data else {
                    print("Empty Data.")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let flickrResponse = try decoder.decode(PhotoID.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(flickrResponse))
                    }
                    
                }catch let error{
                    completion(.failure(error))
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    
    func handler(data: Data?, response: URLResponse?, error: Swift.Error?,completion: @escaping (Result<FlickrResponse, Error>) -> Void) {
        guard let data = data, let httpResponse = response as? HTTPURLResponse else { return }
        
        print("Received \(data.count) bytes with status code \(httpResponse.statusCode).")
        
        
        if httpResponse.statusCode == 200 {
            do {
                let decoder = JSONDecoder()
                let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        completion(.success(flickrResponse))
                    }
                }else {
                    completion(.failure(error!))
                }
                
            }catch let error{
                completion(.failure(error))
            }
        }
        
    }
    
    func getData(lat: Double, long: Double, completion: @escaping (Result<FlickrResponse,Error>) -> Void) {
        
        if let url = URL(string: EndPoint.fillURL(lat: lat, long: long)) {
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            // 3.Give a task
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Data task error. \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Empty Response.")
                    return
                }
                
                print("response status code:\(response.statusCode)")
                
                guard let data = data else {
                    print("Empty Data.")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(flickrResponse))
                    }
                    
                }catch let error{
                    completion(.failure(error))
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
}
