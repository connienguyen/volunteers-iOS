//
//  PaddedRegisteredLabel.swift
//  VOLA
//
//  PaddedRegisteredLabel is a padded label for use in EventCell
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class PaddedRegisteredLabel: RegisteredLabel {

    private let textInsets = UIEdgeInsets(top: 1.5, left: 2.5, bottom: 1.5, right: 2.5)

    // Calculate proper insets due to autolayout
    // See here: https://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accommodate-insets
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}
