//
//  FlikerAPI.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import Foundation

struct EndPoint {
    
    static let flickrBaseURL: String = "https://www.flickr.com/services/rest"
    
    static let photoSearch: String = "flickr.photos.search"
    
    static let apiKey: String = "21f0fc62833b74d78e19b3b6753a8aad"
    
    static func fillURL(lat: Double, long: Double) -> String {
        return flickrBaseURL + "/?method=" + photoSearch + "&api_key=" + apiKey + "&lat=\(lat)&lon=\(long)&radius=20&format=json&nojsoncallback=1"
    }
}

//49953516761

final class FlickrAPI {
    
    static let shared = FlickrAPI()
    private var dataTask: URLSessionDataTask?
    var locations = MapViewController()
    
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
    
    
    func getPopularMoviesData(completion: @escaping (Result<FlickrResponse, Error>) -> Void) {
        
        
        guard let url = URL(string: EndPoint.fillURL(lat: locations.latitude, long: locations.longitude)) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
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
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(FlickrResponse.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
}
