//
//  ViewController.swift
//  Nearby
//
//  Created by Dua Almahyani on 01/12/2020.
//

import UIKit

class MapViewController: UIViewController {

    var pulseLayer: CAShapeLayer!

    let fetchButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "FetchButton"), for: .normal)
        button.addTarget(self, action: #selector(fetchButtonTapped), for: .allEvents)
        return button
    }()
    
    let fetchLabel: UILabel = {
        let label = UILabel()
        label.text = "Fetch"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "mainBGColor")
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainBGColor")
        
        createPulse()
        
        view.addSubview(fetchButton)
        fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fetchButton.anchor(width: 200, height: 200)
        
        view.addSubview(fetchLabel)
        fetchLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fetchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fetchLabel.anchor(top: fetchButton.topAnchor,
                          right: fetchButton.rightAnchor,
                          paddingTop: fetchButton.layer.frame.size.height / 2,
                          paddingRight: 50)
        
    }
    
    
    func createPulse()  {
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
    
    //MARK: - @objc
    @objc func fetchButtonTapped() {
        fetchLabel.textColor = UIColor(named: "Red")
        fetchLabel.text = "Fetching"
        scaleAnimation()
        opacityAnimation()
    }

}

