//
//  HomeContainerViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let animationDuration: TimeInterval = 0.5

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
    var viewModel: EventsViewModel!
    var currentController: ChildControllers = .map

    override func viewDidLoad() {
        super.viewDidLoad()

        DataManager.shared.loadUserIfExists()

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

        viewModel = EventsViewModel()
        viewModel.delegate = self
        eventTablesVC.viewModel = viewModel
        mapEventsVC.viewModel = viewModel
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prompt user to edit location settings if not given and map is current child
        if currentController == .map, let mapVC = firstChildController(currentController) as? MapViewController {
            mapVC.editLocationSettingsIfNeccessary()
        }
    }

    /// Toggle between the table and map children controllers
    func toggleChildView() {
        let currentVC = firstChildController(currentController)
        let newVC = firstChildController(currentController.controllerToToggleTo)

        currentVC.willMove(toParentViewController: nil)
        newVC.view.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        newVC.willMove(toParentViewController: self)
        transition(from: currentVC, to: newVC, duration: animationDuration, options: .curveEaseIn, animations: nil, completion: { _ in
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
    func firstChildController(_ childController: ChildControllers) -> UIViewController {
        switch childController {
        case .table:
            return childViewControllers.first(where: { $0 is EventTableViewController })!
        case .map:
            return childViewControllers.first(where: { $0 is MapViewController })!
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeContainerViewController: UISearchBarDelegate {
    // TODO: Update events based on search terms/filter
}

// MARK: - EventsViewModelDelegate
extension HomeContainerViewController: EventsViewModelDelegate {
    /// Realod the events data for currently visible child view controller
    func reloadEventsView() {
        let currentVC = firstChildController(currentController)
        if let eventTablesVC = currentVC as? EventTableViewController {
            eventTablesVC.tableView.reloadData()
        } else if let mapVC = currentVC as? MapViewController {
            mapVC.reloadLocationMarkers()
        }
    }
}
