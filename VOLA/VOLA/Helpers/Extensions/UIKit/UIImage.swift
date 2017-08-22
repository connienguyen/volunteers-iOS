//
//  UIImage.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/19/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

extension UIImage {
    /**
        Create a masked version of the image with the given color

        - Parameters:
            - color: Color to mask the image with
     
        - Returns: A masked version of the original image if it could be masked
    */
    func maskWithColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let cgImage = self.cgImage else {
            return nil
        }
        context.draw(cgImage, in: rect)
        context.setBlendMode(.sourceIn)
        context.addRect(rect)
        context.drawPath(using: .fill)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImage
    }
}
