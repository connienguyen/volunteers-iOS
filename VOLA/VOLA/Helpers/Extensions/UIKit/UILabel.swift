//
//  UILabel.swift
//  VOLA
//
//  Helper extensions and protocols for UILabel
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

protocol PaddableLabel {
    var textInsets: UIEdgeInsets { get }
}

//  Helper functions for drawing the correct textInset following autolayout
//  to be used with overriding textRect(bounds, numberOfLines)
//  and drawText(in rect)
extension PaddableLabel where Self: UILabel {
    func insetRectFromBounds(_ bounds: CGRect) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        return insetRect
    }

    func invertedInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: -textInsets.top,
                            left: -textInsets.left,
                            bottom: -textInsets.bottom,
                            right: -textInsets.right)
    }
}
