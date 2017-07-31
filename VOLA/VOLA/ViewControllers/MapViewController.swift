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

fileprivate let defaultMarkerTitle: String = ""
fileprivate let locationAccessTitleKey: String = "edit-location-settings.title.label"
fileprivate let locationAccessPromptKey: String = "edit-location-settings.prompt.label"

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    var viewModel: EventsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up location manager and map view
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self

        if let location = locationManager.location {
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: GoogleMapsSettings.cameraZoomLevel)
            mapView.animate(to: camera)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // As child viewcontroller becoming visible again, reload markers
        reloadLocationMarkers()
    }

    /// Clear map view of current markers and load markers from events array
    func reloadLocationMarkers() {
        mapView?.clear()

        for event in viewModel.events where !event.location.isDefaultCoords {
            let marker = GMSMarker(position: CLLocationCoordinate2D(
                latitude: event.location.latitude,
                longitude: event.location.longitude
            ))
            marker.title = String(event.eventID)
            marker.map = mapView
        }
    }

    /// Show event detail view given an event
    func showEventDetail(_ event: Event) {
        let eventDetailVC = EventDetailViewController.instantiateFromXib()
        eventDetailVC.event = event
        show(eventDetailVC, sender: self)
    }

    /**
    Prompt user for access to location if permission was previously denied
    */
    func editLocationSettingsIfNeccessary() {
        // User has not yet been prompted for location access, so no need to show alert to change settings
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }

        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            showEditSettingsAlert(title: locationAccessTitleKey.localized, message: locationAccessPromptKey.localized)
        default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    /// Animate map to last updated location
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

    /// Show alert to edit location authorization if authorization status was changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showEditSettingsAlert(title: locationAccessTitleKey.localized, message: locationAccessPromptKey.localized)
        default:
            break
        }
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    /// Configure and return info window with associated event info
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let mapInfoWindow = EventMapInfoWindow.instantiateFromXib()
        if let event = viewModel.event(with: marker.title ?? defaultMarkerTitle) {
            mapInfoWindow.configureInfoWindow(event: event)
        }

        return mapInfoWindow
    }

    /// Show event detail if user taps on infoWindow
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let event = viewModel.event(with: marker.title ?? defaultMarkerTitle) else {
            Logger.error("Cannot view more detail for associated event.")
            return
        }

        showEventDetail(event)
    }

    /// Calculate new camera position with offset for info window and open info window for tapped marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let markerProjection = mapView.projection.point(for: marker.position)
        let mapCenter = CGPoint(x: markerProjection.x, y: markerProjection.y - EventMapInfoWindow.mapYOffset)
        let mapCenterCoords = mapView.projection.coordinate(for: mapCenter)
        let cameraUpdate = GMSCameraUpdate.setTarget(mapCenterCoords)
        mapView.animate(with: cameraUpdate)
        mapView.selectedMarker = marker

        // Return true to override default Google actions for didTap marker
        return true
    }
}
