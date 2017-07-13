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
    var mapView: GMSMapView?
    var didLayout: Bool = false

    var closestMarkerLocation: CLLocation?
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        // Check if intro slides have been shown before
        let isShownIntro: Bool = DefaultsManager.shared.getBool(forKey: .shownIntro)
        if !isShownIntro {
            let introNavController: IntroductionNavigationController = UIStoryboard(.main).instantiateViewController()
            present(introNavController, animated: true, completion: nil)
        }

        // Set up location manager and map view
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        var camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: -31.012, longitude: 39.123, zoom: 12.0)
        if let location = locationManager.location {
            camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        }
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView

        displayActivityIndicator()
        ETouchesAPIService.shared.getAvailableEvents()
            .then { [weak self] (events) -> Void in
                guard let `self` = self else {
                    return
                }

                self.events = events
                self.reloadEventLocationMarkers()
            }.always { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
            }.catch { error in
                Logger.error(error)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start updating location when returning to
        locationManager.startUpdatingLocation()
    }

    func reloadEventLocationMarkers() {
        self.mapView?.clear()
        guard let currentCenter = locationManager.location,
            let firstLocation = events.first?.location else {
            return
        }

        var closestLocation: CLLocation = CLLocation(latitude: firstLocation.latitude, longitude: firstLocation.longitude)
        for event in events {
            // Only place markers for locations with valid latitude/longitude
            if event.location.latitude != 0.0 && event.location.longitude != 0.0 {
                let markerLocation = CLLocation(latitude: event.location.latitude, longitude: event.location.longitude)
                let marker = GMSMarker(position: markerLocation.coordinate)
                marker.title = event.name
                marker.map = mapView

                if currentCenter.distance(from: closestLocation) > currentCenter.distance(from: markerLocation) {
                    closestLocation = markerLocation
                }
            }
        }

        closestMarkerLocation = closestLocation
        let camera = GMSCameraPosition.camera(withLatitude: closestLocation.coordinate.latitude, longitude: closestLocation.coordinate.longitude, zoom: 17.0)
        self.mapView?.animate(to: camera)
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

// MARK: - CLLocationManagerDeleget
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let closestLocation = closestMarkerLocation ?? locations.last
        guard let location = closestLocation else {
            return
        }

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12.0)
        self.mapView?.animate(to: camera)

        // Stop updating location so map camera does not move
        self.locationManager.stopUpdatingLocation()
    }
}
