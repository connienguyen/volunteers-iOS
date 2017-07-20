//
//  MapViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    var events: [Event] = []
    /// There can only be one marker tapped at a time
    var tappedMarker = GMSMarker()
    /// Currently displayed infoWindow, only one is displayed at a time
    var currentInfoWindow = EventMapInfoWindow.instantiateFromXib()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up location manager and map view
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self

        addNotificationObserver(NotificationName.availableEventsUpdated, selector: #selector(eventsDidUpdate(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start updating location whenever returning to view
        locationManager.startUpdatingLocation()
    }

    /// Clear map view of current markers and load markers from events array
    func reloadLocationMarkers() {
        mapView?.clear()

        for event in events {
            let location = event.location
            // Only place markers for locations with valid latitude/longitude (not (0,0))
            if location.latitude != 0.0 && location.longitude != 0.0 {
                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.latitude,
                            longitude: location.longitude))
                marker.title = String(event.eventID)
                marker.map = mapView
            }
        }
    }

    /// Show event detail view given an event
    func showEventDetail(_ event: Event) {
        let eventDetailVC = EventDetailViewController.instantiateFromXib()
        eventDetailVC.event = event
        show(eventDetailVC, sender: self)
    }

    deinit {
        // Removed here instead of viewWillDisappear so non-active child view controller can still get notifications
        removeNotificationObserver(NotificationName.availableEventsUpdated)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude, zoom: GoogleMapsSettings.cameraZoomLevel)
        self.mapView?.animate(to: camera)

        // Stop updating location so map camera does not move with user
        self.locationManager.stopUpdatingLocation()
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    /// Return an empty view so default Google infoWindow is not used
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }

    /// Update custom info window data when marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        currentInfoWindow.delegate = nil
        currentInfoWindow.removeFromSuperview()
        tappedMarker = marker
        currentInfoWindow = EventMapInfoWindow.instantiateFromXib()
        if let event = events.first(where: { String($0.eventID) == marker.title }) {
            currentInfoWindow.configureInfoWindow(event: event)
            currentInfoWindow.delegate = self
        }
        currentInfoWindow.center = infoWindowCenter(mapView, marker.position)
        //currentInfoWindow.center = mapView.projection.point(for: marker.position)
        // Info window should be subview of main view, not mapView, otherwise it would not be interactive
        view.addSubview(currentInfoWindow)

        return false
    }

    /// Have info window follow map as camera position changes
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        currentInfoWindow.center = infoWindowCenter(mapView, tappedMarker.position)
    }

    /// Close info window when tapped elsewhere on the map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        currentInfoWindow.removeFromSuperview()
    }

    /**
    Calculate center for info window
     
    - Parameters:
        - mapView: Map view used to project location
        - location: Map coordinate to be projected to a CGPoint on screen
     
    - Returns: CGPoint of suggested center of info window
    */
    private func infoWindowCenter(_ mapView: GMSMapView, _ location: CLLocationCoordinate2D) -> CGPoint {
        var markerCenter = mapView.projection.point(for: location)
        markerCenter.y -= GoogleMapsSettings.markerHeightOffset
        return markerCenter
    }
}

// MARK: - EventMapInfoWindowDelegate
extension MapViewController: EventMapInfoWindowDelegate {
    func infoWindow(didTap infoWindow: EventMapInfoWindow) {
        if let event = events.first(where: { $0.eventID == infoWindow.eventID }) {
            // Show detail view controller
            showEventDetail(event)
        }
    }
}

// MARK: - Notification Observer
extension MapViewController {
    /// Reload location markers to match updated events from notification
    func eventsDidUpdate(_ notification: NSNotification) {
        guard let updatedEvents = notification.object as? [Event] else {
            return
        }

        events = updatedEvents
        reloadLocationMarkers()
    }
}
