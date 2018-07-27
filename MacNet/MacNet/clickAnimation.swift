//
//  clickAnimation.swift
//  MacNet
//
//  Created by Samuel Miserendino on 7/27/18.
//  Copyright © 2018 Samuel Miserendino. All rights reserved.
//

import UIKit

@IBDesignable
class clickAnimation: UIView { //when user clicks, a pleasant animation 
    override class var layerClass: AnyClass {
        return coreExpandLayer.self
    }
    
    override func draw(_ rect: CGRect) {}
    
    
}


class coreExpandLayer: CALayer {
    
    var expansionVal: CGFloat = 40
    @objc dynamic public var radius: CGFloat {
        get {
            return expansionVal
        }
        
        set {
            expansionVal = newValue
        }
        
    }
    
    override func draw(in ctx: CGContext) {
        
        let context: CGContext = ctx
        var mainpath = UIBezierPath()
        
            context.addArc(center: CGPoint(x: bounds.width/2, y: bounds.height/2), radius: CGFloat(expansionVal), startAngle: 0, endAngle: .pi * 2, clockwise: false)
            context.setLineWidth(14)
            context.setStrokeColor( UIColor(red: 243/255.0, green: 29/255.0, blue: 19/255.0, alpha: abs((75-radius))/100).cgColor )
            context.strokePath()

    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == #keyPath(radius){
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
        
    }
    
    func expand() {
        let animation = CABasicAnimation(keyPath: #keyPath(radius))
        animation.duration = 1
        animation.fromValue = 20
        animation.toValue = 75
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.add(animation, forKey: #keyPath(radius))
        
    }
    
}

