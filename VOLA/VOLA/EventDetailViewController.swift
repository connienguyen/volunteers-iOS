//
//  EventDetailViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/15/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, XIBInstantiable {

    @IBOutlet weak var registeredLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var volunteersNeededView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sponsoredView: UIView!
    @IBOutlet weak var sponsorImageView: UIImageView!
    @IBOutlet weak var registerView: UIView!

    var event: Event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure stack view here
    }
}

// MARK: - IBActions
extension EventDetailViewController {
    @IBAction func onDirectionsPressed(_ sender: Any) {
        // TODO open map app
    }

    @IBAction func onRegisterPressed(_ sender: Any) {
        // TODO show event registration vc
    }
}
