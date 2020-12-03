//
//  ViewController.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {

    // CoreLocation
    
    let locationManger = CLLocationManager()
    var latitude: Double = 37.7994
    var longitude: Double = 122.3950
    // geocoder
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var isPerformingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    // UI Components
    
    var pulseLayer: CAShapeLayer!

    lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 270))
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let image = UIImage(named: "Ellipse")
        pulseLayer = CAShapeLayer()
        pulseLayer.path = circularPath.cgPath
        pulseLayer.strokeColor = UIColor.clear.cgColor
        pulseLayer.lineWidth = 10
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.bounds = CGRect(x: 0, y: 0 , width: 180, height: 180)
        pulseLayer.contents = image?.cgImage
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.position = view.center
        view.layer.addSublayer(pulseLayer)
        
        return view
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    
    let fetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch", for: .normal)
        button.titleLabel?.font = UIFont(name: "Menlo", size: 20)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let fetchAboveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "FetchButton"), for: .normal)
        return button
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    let mapImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "map")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainBGColor")
        
        updateUI()
        setupLocationManger()
        
    }
    
    //MARK: - Functions
    
    func updateUI() {
        
        view.addSubview(mapImage)
        mapImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        mapImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 60, paddingLeft: 10, paddingRight: 10)

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        view.addSubview(currentTimeLabel)
        currentTimeLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        currentTimeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        
        view.addSubview(countryLabel)
       countryLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
       countryLabel.anchor(top: currentTimeLabel.bottomAnchor, paddingTop: 5)
        
        view.addSubview(cityLabel)
        cityLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        cityLabel.anchor(top: countryLabel.bottomAnchor, paddingTop: 10)

        view.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        containerView.anchor(top: mapImage.bottomAnchor,
                             paddingTop: 15,
                             width: 270, height: 270)
        
        view.addSubview(fetchAboveButton)
        fetchAboveButton.anchor(top: mapImage.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingTop: 50,
                           width: 200, height: 200)
        
        view.addSubview(fetchButton)
        fetchButton.anchor(top: mapImage.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingTop: 50,
                           width: 200, height: 200)
        
        if let placemark = placemark {
            countryLabel.text = getCountry(from: placemark)
            cityLabel.text = getCity(from: placemark)
        } else if isPerformingReverseGeocoding {
            countryLabel.text = "Serching..."
            cityLabel.text = "Serching..."
        } else if lastGeocodingError != nil {
            countryLabel.text = "error :("
            cityLabel.text = "error :("
        } else {
            countryLabel.text = "not found"
            cityLabel.text = "not found"
        }
    }
    
    
    private func scaleAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 4
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    private func opacityAnimation() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseLayer.add(animation, forKey: "fade")
    }
    
    func setupLocationManger() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }
    
    func getCountry(from placemark: CLPlacemark) -> String {
        var countryString = ""
        if let country = placemark.country {
            countryString += country
        }
        
        return countryString
    }
    
    func getCity(from placemark: CLPlacemark) -> String {
        var cityString = ""
        if let country = placemark.locality {
            cityString += country
        }
        
        return cityString
    }
    
    
    
    //MARK: - Selectors
    
    @objc func updateTime() {
        let now = Date()
        currentTimeLabel.text = dateFormatter.string(from: now)
    }
    
    @objc func fetchButtonTapped() {
        fetchButton.setTitle("Fetching", for: .normal)
        fetchButton.setTitleColor(UIColor(named: "mainBGColor"), for: .normal)
        
        scaleAnimation()
        opacityAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            FlickrAPI.shared.fetchList(lat: "37.7994", long: "122.3950")
            
            self.pulseLayer.removeAllAnimations()
            self.fetchButton.setTitle("Done!", for: .normal)
            self.performSegue(withIdentifier: "collectionVC", sender: nil)
        }
    }

}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        
        print("latitude: \(latitude), logitude: \(longitude)")
        
        if location != nil {
            if !isPerformingReverseGeocoding {
                print("*** Start performing geocoding ***")
                isPerformingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    self.lastGeocodingError = error
                    if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                        self.placemark = placemarks.last!
                    }else {
                        self.placemark = nil
                    }
                    
                    self.isPerformingReverseGeocoding = false
                    self.updateUI()
                }
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed, \(error)")
    }
}

/*
 photoID: "49953516761", dateTaken: nil),
 Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953019053", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953019063", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953804272", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953516751", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953019078", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953804212", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953804197", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953804217", dateTaken: nil), Nearby.FlickrPhoto(title: "", remoteURL: nil, photoID: "49953516736", dateTaken: nil),
*/
