//
//  VLInputTextView.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let inputBorderWidth: CGFloat = 0.5
fileprivate let viewCornerRadius: CGFloat = 3.0

/// Stylized text view used for longer text input (over text field)
class VLInputTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = inputBorderWidth
        layer.cornerRadius = viewCornerRadius
    }
}
