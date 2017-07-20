//
//  CircleImageView.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Stylized image view to display images in a circular view
class CircleImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ThemeManager.shared.currentTheme.accentColor
        layer.masksToBounds = false
        layer.cornerRadius = frame.height/2.0
        clipsToBounds = true
    }
}
