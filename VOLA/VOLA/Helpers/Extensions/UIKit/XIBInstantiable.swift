//
//  XIBInstantiable.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Protocol to allow class to be instantiated from an XIB file
protocol XIBInstantiable {
    static var associatedNib: UINib { get }
}

extension XIBInstantiable {
    /// Nib for storyboard elements
    static var associatedNib: UINib {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle.main)
    }

    /// Instantiate storyboard element from XIB file
    static func instantiateFromXib() -> Self {
        guard let view =  associatedNib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load from nib.")
        }

        return view
    }
}
