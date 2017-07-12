//
//  VolunteersNeededLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Padded stylized label to display that an event is in need of volunteers
class VolunteersNeededLabel: UILabel, PaddableLabel {
    var textInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0.5, left: 3.0, bottom: 0.5, right: 3.0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        textColor = ThemeColors.white
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
