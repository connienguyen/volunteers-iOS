//
//  EventMapInfoWindow.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

fileprivate let windowBorderWidth: CGFloat = 1.0
fileprivate let windowCornerRadius: CGFloat = 7.0
fileprivate let windowWidth: CGFloat = 295.0

/// Popup view shown when map marker is clicked
class EventMapInfoWindow: UIView, XIBInstantiable {
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var dateAddressLabel: TextLabel!
    @IBOutlet weak var registrationLabel: TextLabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = ThemeManager.shared.currentTheme.inputBorderColor.cgColor
        layer.borderWidth = windowBorderWidth
        layer.cornerRadius = windowCornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: windowWidth)
        addConstraint(widthConstraint)
    }

    /**
    Configure the label displays in the info window to match associated event
     
    - Parameters:
        - event: Event model to display data from
    */
    func configureInfoWindow(event: Event) {
        nameLabel.text = event.name
        dateAddressLabel.text = event.location.shortAddressString
    }
}
