//
//  EventMapInfoWindow.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

protocol EventMapInfoWindowDelegate: class {
    func infoWindow(didTap infoWindow: EventMapInfoWindow)
}

/// Popup view shown when map marker is clicked
class EventMapInfoWindow: UIView, XIBInstantiable {
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var dateAddressLabel: TextLabel!
    @IBOutlet weak var registrationLabel: TextLabel!

    weak var delegate: EventMapInfoWindowDelegate?
    var eventID: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = ThemeColors.lightGrey.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 7.0

        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infoWindowTapped))
        addGestureRecognizer(tapGesture)
    }

    /**
    Configure the label displays in the info window to match associated event
     
    - Parameters:
        - event: Event model to display data from
    */
    func configureInfoWindow(event: Event) {
        eventID = event.eventID
        nameLabel.text = event.name
        dateAddressLabel.text = event.location.addressString
    }

    /// Pass tap event on EventMapInfoWindow to delegate
    func infoWindowTapped(_ sender: UITapGestureRecognizer) {
        delegate?.infoWindow(didTap: self)
    }
}
