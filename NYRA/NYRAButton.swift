//
//  NYRAButton.swift
//  NYRA
//
//  Created by Joey on 1/3/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import UIKit

class NYRAButton: UIButton {
    
    let pathLayer: CAShapeLayer = CAShapeLayer()
    
    func drawGold() {
        let realFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let path: UIBezierPath = UIBezierPath(rect: realFrame)
        
        //Create a CAShape Layer
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.primrose().cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1.0
        pathLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(pathLayer)
        
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //Animation will happen right away
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
    }
}
