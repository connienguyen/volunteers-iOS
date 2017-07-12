//
//  RoundedImageView.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
Stylized image view to display image in a rounder rectangular view
*/
class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ThemeManager.shared.currentTheme.accentColor
        layer.cornerRadius = 5.0
    }
}
