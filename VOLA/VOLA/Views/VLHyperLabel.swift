//
//  VLHyperLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

/**
Helper struct for associating handlers with links
 
 - linkText: Text to appear as a link
 - linkHandler: Action on link click
*/
struct HyperHandler {
    let linkText: String
    let linkHandler: VoidCompletionBlock
}

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
    Set up label and associated handlers
     
    - Parameters:
        - fullText: String of full label text
        - fontSize: Font size for attributed string
        - handlers: Array of link handlers
    */
    func setUpLabel(_ fullText: String, textSize: TextSize, handlers: [HyperHandler]) {
        setAttributedString(fullText, fontSize: textSize.fontSize)

        for handler in handlers {
            setLinkForSubstring(handler.linkText, withLinkHandler: { (_, _) in
                handler.linkHandler()
            })
        }
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
