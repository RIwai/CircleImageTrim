//
//  CircleHollowView.swift
//  CircleImageTrim
//
//  Created by Ryota Iwai on 2015/10/19.
//  Copyright © 2015年 Ryota Iwai. All rights reserved.
//

import UIKit

class CircleHollowView: UIView {

    // MARK: - Lazy peperties
    lazy var hollowPoint: CGPoint = {
        return CGPoint(
            x: self.bounds.width / 2.0,
            y: self.bounds.height / 2.0
        )
    }()
    
    lazy var hollowRadius: CGFloat = {
       return (self.bounds.width / 2) - 2
    }()

    lazy var ovalRect: CGRect = {
        return CGRect(
            x: self.hollowPoint.x - self.hollowRadius,
            y: self.hollowPoint.y - self.hollowRadius,
            width: self.hollowRadius * 2.0,
            height: self.hollowRadius * 2.0
        )
    }()
    
    lazy var hollowLayer: CALayer = {
        let hollowTargetLayer = CALayer()
        hollowTargetLayer.bounds = self.bounds
        hollowTargetLayer.position = CGPoint(
            x: CGRectGetWidth(self.bounds) / 2.0,
            y: CGRectGetHeight(self.bounds) / 2.0
        )
        hollowTargetLayer.backgroundColor = UIColor.blackColor().CGColor
        hollowTargetLayer.opacity = 0.7
        
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = hollowTargetLayer.bounds
        
        let path =  UIBezierPath(ovalInRect: self.ovalRect)
        path.appendPath(UIBezierPath(rect: maskLayer.bounds))
        
        maskLayer.fillColor = UIColor.blackColor().CGColor
        maskLayer.path = path.CGPath
        maskLayer.position = CGPoint(
            x: CGRectGetWidth(hollowTargetLayer.bounds) / 2.0,
            y: CGRectGetHeight(hollowTargetLayer.bounds) / 2.0
        )

        maskLayer.fillRule = kCAFillRuleEvenOdd
        hollowTargetLayer.mask = maskLayer
        return hollowTargetLayer
    }()

    lazy var circleLayer: CAShapeLayer = {
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = 2
        
        ovalShapeLayer.path = UIBezierPath(ovalInRect: self.ovalRect).CGPath
        
        return ovalShapeLayer
    }()

    // MARK: - Private peperties
    private var isAddSubLayer: Bool = false
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        
        if self.frame.width != UIScreen.mainScreen().bounds.width {
            return
        }
        if self.isAddSubLayer {
            return
        }

        layer.addSublayer(self.hollowLayer)
        layer.addSublayer(self.circleLayer)
        self.isAddSubLayer = true
    }
}
