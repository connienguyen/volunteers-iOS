//
//  HomeContainerViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeContainerViewController: UIViewController {
    /**
    Possible child controllers for HomeContainerViewController
     
    - table: EventsTableViewController for viewing events in a list
    - map: MapViewController for viewing events on a map
    */
    enum ChildControllers: String {
        case table = "list.prompt.label"
        case map = "map.prompt.label"

        /// Display text for toggle button between children controllers
        var localizedToggleButtonText: String {
            return controllerToToggleTo.rawValue.localized
        }

        /// Controller container should toggle to
        var controllerToToggleTo: ChildControllers {
            switch self {
            case .table:
                return .map
            case .map:
                return .table
            }
        }
    }

    @IBOutlet weak var container: UIView!

    let searchPromptKey = "search.prompt.label"
    var events: [Event] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationName.availableEventsUpdated, object: events)
        }
    }
    private var currentController: ChildControllers = .map

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar()
        searchBar.placeholder = searchPromptKey.localized
        let toggleButton = UIBarButtonItem(title: ChildControllers.map.localizedToggleButtonText,
            style: .plain, target: self, action: #selector(toggleChildView))
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = toggleButton

        // Embed map as default child vc
        let eventTablesVC = EventTableViewController.instantiateFromXib()
        eventTablesVC.tableType = .home
        addChildViewController(eventTablesVC)
        let mapEventsVC: MapViewController = UIStoryboard(.home).instantiateViewController()
        addChildViewController(mapEventsVC)
        mapEventsVC.view.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        container.addSubview(mapEventsVC.view)
        mapEventsVC.didMove(toParentViewController: self)
        currentController = .map

        ETouchesAPIService.shared.getAvailableEvents()
            .then { events in
                self.events = events
            }.catch { error in
                Logger.error(error)
            }
    }

    /// Toggle between the table and map children controllers
    func toggleChildView() {
        let currentVC = firstChildController(currentController)
        let newVC = firstChildController(currentController.controllerToToggleTo)
        guard let currentChild = currentVC, let newChild = newVC else {
            return
        }

        currentChild.willMove(toParentViewController: nil)
        newChild.view.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        newChild.willMove(toParentViewController: self)
        transition(from: currentChild, to: newChild, duration: 0.5, options: .curveEaseIn, animations: nil, completion: { _ in
            self.currentController = self.currentController.controllerToToggleTo
            self.navigationItem.rightBarButtonItem?.title = self.currentController.localizedToggleButtonText
        })
    }

    /**
    Find given child controller
     
    - Parameters:
        - childController: Type of child controller to return; there should only be one of each child
     
    - Returns: Child view controller matching specified type
    */
    func firstChildController(_ childController: ChildControllers) -> UIViewController? {
        switch childController {
        case .table:
            return childViewControllers.first(where: { $0 is EventTableViewController })
        case .map:
            return childViewControllers.first(where: { $0 is MapViewController })
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeContainerViewController: UISearchBarDelegate {
    // TODO: Update events based on search terms/filter
}
