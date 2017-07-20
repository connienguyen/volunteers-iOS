//
//  VolunteersNeededLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let topPadding: CGFloat = 0.5
fileprivate let leftPadding: CGFloat = 3.0
fileprivate let bottomPadding: CGFloat = 0.5
fileprivate let rightPadding: CGFloat = 3.0

/// Padded stylized label to display that an event is in need of volunteers
class VolunteersNeededLabel: UILabel, PaddableLabel {
    var textInsets: UIEdgeInsets {
        return UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = insetRectFromBounds(bounds)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets())
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}
