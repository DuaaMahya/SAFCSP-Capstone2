//
//  PulseAnimation.swift
//  Nearby
//
//  Created by Dua Almahyani on 02/12/2020.
//

import UIKit

class Pulse: CALayer {
    
    var animationGroup = CAAnimationGroup()
    var initialPulse:       Float            = 0
    var nextPulse:          TimeInterval     = 0
    var animationDuration:  TimeInterval     = 1.5
    var radius:             CGFloat          = 200
    var numberOfPulses:     Float            = Float.infinity
    
    
    override init(layer: Any) {
        super.init(layer: layer)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(numberOfPulses: Float = Float.infinity, radius: CGFloat, position: CGPoint) {
        super.init()
        
        self.shadowColor = UIColor.darkGray.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: "transform.scale.xy")
        scale.fromValue = NSNumber(value: initialPulse)
        scale.toValue = NSNumber(value: 1)
        scale.duration = animationDuration
        return scale
    }
    
    func opacityAnimation() -> CAKeyframeAnimation {
        let opacity = CAKeyframeAnimation(keyPath: "opacity")
        opacity.values = [0.4, 0.8, 1]
        opacity.keyTimes = [0, 0.2, 1]
        return opacity
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulse
        self.animationGroup.repeatCount = numberOfPulses
        let defultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defultCurve
        
        self.animationGroup.animations = [scaleAnimation(), opacityAnimation()]
    }
    
}
