//
//  EventCell.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

/// Custom table cell for displaying basic information about an event
class EventCell: UITableViewCell {
    static let estimatedHeight: CGFloat = 250.0

    @IBOutlet weak var eventImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var registeredLabel: PaddedRegisteredLabel!

    /**
    Configure display elements of cell to display Event details
     
    - Parameters:
        - event: Event data source to display details from
    */
    func configureCell(event: Event) {
        nameLabel.text = event.name
        addressLabel.text = event.location.addressString
        registeredLabel.eventType = event.eventType

        if let eventImageURL = event.eventImageURL {
            eventImageView.kf.setImage(with: eventImageURL)
        } else {
            // In case of cell reuse, don't want old image appearing
            eventImageView.image = nil
        }
    }
}
