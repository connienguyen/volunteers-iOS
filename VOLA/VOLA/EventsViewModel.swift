//
//  EventsViewModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/20/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/**
ViewModel for view controllers that display information from an array of Events
 (e.g. EventTableViewController, MapViewController)
*/
class EventsViewModel {
    private var _events: [Event]
    var reloadViewCallback: (() -> ())
    var events: [Event] {
        return _events
    }
    var eventCount: Int {
        return _events.count
    }

    init(callback: @escaping (() -> ())) {
        self._events = []
        self.reloadViewCallback = callback
        retrieveAvailableEvents()
    }

    func event(with eventID: String) -> Event? {
        return _events.first(where: { String($0.eventID) == eventID })
    }

    func event(at index: Int) -> Event {
        return _events[index]
    }

    func retrieveAvailableEvents() {
        ETouchesAPIService.shared.getAvailableEvents()
            .then { (events) -> Void in
                self._events = events
                self.reloadViewCallback()
            }.catch { error in
                Logger.error(error)
            }
    }
}
