//
//  UIImage.swift
//  CircleImageTrim
//
//  Created by Ryota Iwai on 2015/10/19.
//  Copyright © 2015年 Ryota Iwai. All rights reserved.
//

import UIKit

extension UIImage {

    func trimImage(trimRect trimRect :CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.drawInRect(CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return trimmedImage
    }
}
