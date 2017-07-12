//
//  PaddedRegisteredLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Padded label for use in EventCell
class PaddedRegisteredLabel: RegisteredLabel, PaddableLabel {
    var textInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 1.5, left: 2.5, bottom: 1.5, right: 2.5)
    }

    // Calculate proper insets due to autolayout
    // See here: https://stackoverflow.com/questions/21167226/resizing-a-uilabel-to-accommodate-insets
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = insetRectFromBounds(bounds)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets())
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}
