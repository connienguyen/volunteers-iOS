//
//  EventsViewModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/20/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Protocol for views displaying changes on EventsViewModel
protocol EventsViewModelDelegate: class {
    /// Reload view displaying data from EventsViewModel to reflect changes to viewmodel data
    func reloadEventsView()
}

/**
ViewModel for view controllers that display information from an array of Events
 (e.g. EventTableViewController, MapViewController)
*/
class EventsViewModel {
    private var _events: [Event] = []
    weak var delegate: EventsViewModelDelegate?
    /// Publically accessible array of event models
    var events: [Event] {
        return _events
    }
    /// Length of events array (for use with table views)
    var eventCount: Int {
        return _events.count
    }

    /// Initialize view model and retrieve available events
    init() {
        retrieveAvailableEvents()
    }

    /**
    Find event in data array given eventID if it exists
     
    - Parameters:
        - eventID: eventID of Event to retrieve as a String
     
    - Returns: Event with matching eventID if it exists, otherwise nil
    */
    func event(with eventID: String) -> Event? {
        return _events.first(where: { String($0.eventID) == eventID })
    }

    /**
    Find event given index
     
    - Parameters:
        - index: Array index for Event in array
     
    - Returns: Event in data array given an index
    */
    func event(at index: Int) -> Event {
        return _events[index]
    }

    /**
    Reload events array with data from eTouches API and call reloadViewCallback
    */
    func retrieveAvailableEvents() {
        ETouchesAPIService.shared.getAvailableEvents()
            .then { (events) -> Void in
                self._events = events
                self.delegate?.reloadEventsView()
            }.catch { error in
                Logger.error(error)
            }
    }
}
