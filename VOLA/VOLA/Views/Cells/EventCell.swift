//
//  EventCell.swift
//  VOLA
//
//  EventCell is a custom table view cell used to for displaying basic
//  information about an event.
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

class EventCell: UITableViewCell {
    static let estimatedHeight: CGFloat = 250.0

    @IBOutlet weak var eventImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var registeredLabel: UILabel!

    func configureCell(event: Event) {
        nameLabel.text = event.name
        addressLabel.text = event.location.addressString
        registeredLabel.isHidden = event.eventType == .unregistered
        registeredLabel.text = event.eventType.labelText

        if let eventImageURL = event.eventImageURL {
            eventImageView.kf.setImage(with: eventImageURL)
        } else {
            // In case of cell reuse, don't want old image appearing
            eventImageView.image = nil
        }
    }
}
