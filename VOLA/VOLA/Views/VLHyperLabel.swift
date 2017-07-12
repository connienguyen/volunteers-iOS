//
//  VLHyperLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

/// Stylized HyperLabel (label with clickable links)
class VLHyperLabel: FRHyperLabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        linkAttributeDefault = [
            NSForegroundColorAttributeName: ThemeManager.shared.currentTheme.linkColor,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
        ]
    }

    /**
    Set attributed text for label
     
    - Parmaeters:
        - string: Text for label
        - fontSize: Font size for label text
    */
    func setAttributedString(_ string: String, fontSize: CGFloat) {
        let labelAttributes = [
                NSForegroundColorAttributeName: ThemeManager.shared.currentTheme.textColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)
        ]
        attributedText = NSAttributedString(string: string, attributes: labelAttributes)
    }
}
