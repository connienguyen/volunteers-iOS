//
//  HomeViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation
import GoogleMaps

/// View controller where user can view available events in their area on a map view
class HomeViewController: UIViewController {

    let locationManager = CLLocationManager()
    var didLayout: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if intro slides have been shown before
        let isShownIntro: Bool = DefaultsManager.shared.getBool(forKey: .shownIntro)
        if !isShownIntro {
            let introNavController: IntroductionNavigationController = UIStoryboard(.main).instantiateViewController()
            present(introNavController, animated: true, completion: nil)
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        guard let currentLocation = locationManager.location else {
            return
        }

        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }
}

// MARK: - IBActions
extension HomeViewController {
    @IBAction func onGetDetailPressed(_ sender: Any) {

        displayActivityIndicator()
        ETouchesAPIService.shared.getEventDetail(eventID: ETouchesParameters.mockEventID)
            .then { [weak self] (event) -> Void in
                guard let `self` = self else {
                    return
                }

                let eventDetailVC = EventDetailViewController.instantiateFromXib()
                eventDetailVC.event = event
                self.removeActivityIndicator()
                self.navigationController?.show(eventDetailVC, sender: self)
            }.catch { error in
                Logger.error(error)
            }
    }
}
