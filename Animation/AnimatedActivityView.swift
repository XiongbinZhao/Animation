//
//  AnimatedView.swift
//  Animation
//
//  Created by Zhao Xiongbin on 2016-08-23.
//  Copyright © 2016 XiongbinZhao. All rights reserved.
//

import UIKit
import CoreMotion

class AnimatedActivityIndicatorView: UIView, UICollisionBehaviorDelegate {
    
    var searchingString = "Searching Flights"
    var indicatorCenter = CGPointZero
    
    private let planeTopImage = UIImage(named: "plane4")
    private let planeMiddleImage = UIImage(named: "plane1")
    private let planeBottomImage = UIImage(named: "plane2")
    private let planeImageView = UIImageView()
    
    private let cloudImagesContainer = UIView()
    
    private let cityImagesContainer = UIView()
    
    private let sunImagesContainer = UIView()
    private let sunImageView = UIImageView(image: UIImage(named: "Sun"))
    
    private var gravityBehavior: UIGravityBehavior!
    private let gravityAnimator = UIDynamicAnimator()
    
    private let motionManager = CMMotionManager()
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 0.902, green: 0.914, blue: 0.925, alpha: 1.00)
        
        //Cities Images
        let imageNames = ["Toronto", "Newyork", "London", "Toronto"]
        
        let cityHeightRatio = CGFloat(120.00/568.00)
        cityImagesContainer.frame.size = CGSize(width: frame.size.width * CGFloat(imageNames.count), height: frame.height * cityHeightRatio)
        cityImagesContainer.frame.origin = CGPoint(x: 0, y: frame.height - cityImagesContainer.frame.height - 40)
        
        cityImagesContainer.layer.anchorPoint = CGPointZero
        cityImagesContainer.layer.position = CGPoint(x: 0, y: frame.height - cityImagesContainer.frame.height - 40)
        
        let lineBarView = UIView(frame: CGRect(x: 0, y: cityImagesContainer.frame.height - 1, width: cityImagesContainer.frame.width * CGFloat(imageNames.count), height: 1))
        lineBarView.backgroundColor = UIColor(red: 0.800, green: 0.808, blue: 0.820, alpha: 1.00)
        cityImagesContainer.addSubview(lineBarView)
        
        for idx in 0..<imageNames.count {
            guard let cityImage = UIImage(named: imageNames[idx]) else {
                return
            }
            
            let imageRatio = cityImage.size.width / cityImage.size.height
            let cityImageView = UIImageView()
            cityImageView.frame.size = CGSize(width: imageRatio * cityImagesContainer.frame.height, height: cityImagesContainer.frame.height)
            cityImageView.frame.origin = CGPoint(x: CGRectGetMidX(frame) + frame.width * CGFloat(idx) - cityImageView.frame.width/2, y: 0)
            cityImageView.image = cityImage
            cityImagesContainer.addSubview(cityImageView)
        }
        
        addSubview(cityImagesContainer)
        
        //Cloud Image
        let cloudHeightRatio = CGFloat(161.00/568.00)
        cloudImagesContainer.frame.size = CGSize(width: frame.width * 2, height: frame.height * cloudHeightRatio)
        cloudImagesContainer.frame.origin = CGPoint(x: 0, y: cityImagesContainer.frame.origin.y - cloudImagesContainer.frame.height - 30)
        
        guard let cloudImage = UIImage(named: "clouds") else {
            return
        }
        
        let cloudImageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: frame.width, height: cloudImagesContainer.frame.height))
        cloudImageView1.image = cloudImage
        
        let cloudImageView2 = UIImageView(frame: CGRect(x: cloudImageView1.frame.origin.x + cloudImageView1.frame.width + 30, y: 0, width: frame.width, height: cloudImagesContainer.frame.height))
        cloudImageView2.image = cloudImage
        
        cloudImagesContainer.addSubview(cloudImageView1)
        cloudImagesContainer.addSubview(cloudImageView2)
        
        //Sun Image
        let widthRatio = CGFloat(106.00/704.00)
        let length = widthRatio * frame.width
        sunImageView.frame.size = CGSize(width: length, height: length)
        sunImageView.frame.origin = CGPoint(x: frame.width - 50 - sunImageView.frame.width, y: cloudImagesContainer.frame.origin.y - 5)
        sunImageView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        sunImageView.layer.position = CGPoint(x: frame.width - 50 - sunImageView.frame.width, y: cloudImagesContainer.frame.origin.y - 5)

        //Plane Images
        guard let planeImage = planeMiddleImage else {
            return
        }
        
        let planeImageRatio = planeImage.size.width / planeImage.size.height
        
        planeImageView.image = planeImage
        
        let planeWidthRatio = CGFloat(329.00/740.00)
        planeImageView.frame.size = CGSize(width: planeWidthRatio * frame.width, height: planeWidthRatio * frame.width / planeImageRatio)
        planeImageView.frame.origin = CGPoint(x: 20, y: cloudImagesContainer.center.y - planeImageView.frame.height/2)
        
        addSubview(sunImageView)
        addSubview(planeImageView)
        addSubview(cloudImagesContainer)
        
        //Indicator
        let indicatorView = UIView()
        indicatorView.frame.size = CGSize(width: 58, height: 58)
        indicatorView.backgroundColor = UIColor.redColor()
        indicatorView.center = CGPoint(x: CGRectGetMidX(frame), y: cloudImagesContainer.frame.origin.y/2 - 15 )
        addSubview(indicatorView)
        
        indicatorCenter = indicatorView.center
        
        //Searching Label
        let searchingLabel = UILabel(frame: CGRect(x: 0, y: indicatorView.frame.origin.y + indicatorView.frame.height + 15, width: frame.width, height: 30))
        searchingLabel.text = searchingString
        searchingLabel.textAlignment = NSTextAlignment.Center
        searchingLabel.textColor = UIColor(red: 0.067, green: 0.380, blue: 0.655, alpha: 1.00)
        searchingLabel.font = UIFont.systemFontOfSize(22.0)
        searchingLabel.adjustsFontSizeToFitWidth = true
        addSubview(searchingLabel)
        
        //Gravity Behavior
        gravityBehavior = UIGravityBehavior(items: [planeImageView])
        gravityBehavior.magnitude = 0.0
        self.gravityAnimator.addBehavior(gravityBehavior)
        
        let planeBoundaryOffset = CGFloat(3.0)
        
        let collisionBehavior = UICollisionBehavior(items: [planeImageView])
        let leftUpperCloudPoint = CGPoint(x: cloudImagesContainer.frame.origin.x, y: cloudImagesContainer.frame.origin.y + planeBoundaryOffset)
        let rightUpperCloudPoint = CGPoint(x: cloudImagesContainer.frame.width, y: cloudImagesContainer.frame.origin.y + planeBoundaryOffset)
        let leftLowerCloudPoint = CGPoint(x: 0, y: cloudImagesContainer.frame.origin.y + cloudImagesContainer.frame.height - planeBoundaryOffset)
        let rightLowerCloudPoint = CGPoint(x: cloudImagesContainer.frame.width, y: cloudImagesContainer.frame.origin.y + cloudImagesContainer.frame.height - planeBoundaryOffset)
        collisionBehavior.addBoundaryWithIdentifier("upperBoundary", fromPoint: leftUpperCloudPoint, toPoint: rightUpperCloudPoint)
        collisionBehavior.addBoundaryWithIdentifier("lowerBoundary", fromPoint: leftLowerCloudPoint, toPoint: rightLowerCloudPoint)
        collisionBehavior.collisionDelegate = self
        self.gravityAnimator.addBehavior(collisionBehavior)
        
        let itemBehavior = UIDynamicItemBehavior(items: [planeImageView])
        itemBehavior.elasticity = 0.0
        self.gravityAnimator.addBehavior(itemBehavior)

        //CMMotionManager
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.gyroUpdateInterval = 0.2
            
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                [weak self] (data: CMGyroData?, error: NSError?) in
                if let rotation = data?.rotationRate {
                    if rotation.x >= 1 {
                        //Down
                        self?.gravityBehavior.gravityDirection = CGVector(dx: 0.0, dy: 0.02)
                        
                        if self?.planeImageView.image != self?.planeBottomImage {
                            self?.planeImageView.image = self?.planeBottomImage
                        }
                        
                    } else if rotation.x <= -1 {
                        //Up
                        self?.gravityBehavior.gravityDirection = CGVector(dx: 0.0, dy: -0.02)
                        
                        if self?.planeImageView.image != self?.planeTopImage {
                            self?.planeImageView.image = self?.planeTopImage
                        }
                        
                    }
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimating() {
        
        //Animation for clouds
        let cloudAnim = CABasicAnimation(keyPath: "transform.translation.x")
        cloudAnim.fromValue = NSNumber(float: 0.0)
        cloudAnim.toValue = NSNumber(float: Float(self.cloudImagesContainer.frame.origin.x - (self.frame.width + 30)))
        cloudAnim.duration = 4.0
        cloudAnim.repeatCount = Float.infinity
        cloudAnim.fillMode = kCAFillModeForwards
        cloudAnim.removedOnCompletion = false
        cloudImagesContainer.layer.addAnimation(cloudAnim, forKey: "Clouds")
        
        //Animation for sun
        let sunAnim1 = CABasicAnimation(keyPath: "position.x")
        sunAnim1.toValue = -self.sunImageView.frame.width
        sunAnim1.duration = 35
        sunAnim1.beginTime = 0
        sunAnim1.fillMode = kCAFillModeForwards
        sunAnim1.removedOnCompletion = false
        
        let sunAnim2 = CABasicAnimation(keyPath: "position.x")
        sunAnim2.fromValue = self.frame.width
        sunAnim2.toValue = self.frame.width - self.sunImageView.frame.width - 50
        sunAnim2.duration = 15
        sunAnim2.beginTime = 35
        sunAnim2.fillMode = kCAFillModeForwards
        sunAnim2.removedOnCompletion = false
        
        let sunGroupAnim = CAAnimationGroup()
        sunGroupAnim.animations = [sunAnim1, sunAnim2]
        sunGroupAnim.duration = 50
        sunGroupAnim.repeatCount = Float.infinity
        sunGroupAnim.fillMode =  kCAFillModeForwards
        sunGroupAnim.removedOnCompletion = false
        
        self.sunImageView.layer.addAnimation(sunGroupAnim, forKey: "Sun")
        
        //Animation for cities
        var animationsArray = [CABasicAnimation]()
        for i in 0..<3 {
            let anim = CABasicAnimation(keyPath: "position.x")
            anim.fromValue = NSNumber(double: Double(-i) * Double(self.frame.width))
            anim.byValue = -self.frame.width
            anim.duration = 1.0
            anim.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.25, 1.00)
            anim.beginTime = Double(i) * 4 + 3
            anim.fillMode = kCAFillModeForwards
            anim.removedOnCompletion = false
            animationsArray.append(anim)
        }
        
        let group = CAAnimationGroup()
        group.animations = animationsArray
        group.duration = 12
        group.beginTime = CACurrentMediaTime()
        group.repeatCount = Float.infinity
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        
        self.cityImagesContainer.layer.addAnimation(group, forKey: "City")
    }
    
    //MARK: UICollisionBehabivor Delegate
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint)
    {
        self.planeImageView.image = planeMiddleImage
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?)
    {
        if let identifier = identifier as? String where identifier == "upperBoundary"{
            self.planeImageView.image = planeBottomImage
        } else {
            self.planeImageView.image = planeTopImage
        }
    }
}
