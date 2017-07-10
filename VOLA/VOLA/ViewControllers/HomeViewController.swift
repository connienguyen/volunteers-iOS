//
//  HomeViewController.swift
//  VOLA
//
//  View controller where user can view available events in their area
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {

    var didLayout: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if intro slides have been shown before
        let isShownIntro = Defaults.getObject(forKey: .shownIntro) as? Bool ?? false
        if !isShownIntro {
            let introNavController: IntroductionNavigationController = UIStoryboard(.main).instantiateViewController()
            present(introNavController, animated: true, completion: nil)
        }
    }
}

// MARK: - IBActions
extension HomeViewController {
    @IBAction func onGetDetailPressed(_ sender: Any) {

        displayActivityIndicator()
        ETouchesAPIService.shared.getEventDetail(eventID: 1)
            .then { [weak self] (event) -> Void in
                guard let `self` = self else {
                    return
                }

                let eventDetailVC = EventDetailViewController.instantiateFromXib()
                eventDetailVC.event = event
                self.removeActivityIndicator()
                self.navigationController?.show(eventDetailVC, sender: self)
            }.catch { error in
                Logger.error(error.localizedDescription)
            }
    }
}
