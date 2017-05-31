import Foundation
import UIKit

extension String {

    /// localize string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel {
    /// localization key that will overwrite the label text.
    @IBInspectable var localizeKey: String {
        set (key) {
            text = key.localized
        }
        get {
            return text!
        }
    }
}

extension UIButton {
    /// localization key for button normal state.
    @IBInspectable var localizeKeyForNormal: String {
        set (key) {
            setTitle(key.localized, for: .normal)
        }
        get {
            return title(for: .normal)!
        }
    }
}

extension UITabBarItem {
    /// localization key that overwrites the text.
    @IBInspectable var localizeKey: String {
        set (key) {
            title = key.localized
        }
        get {
            return title!
        }
    }
}

extension UINavigationItem {
    /// localization key that overwrites the title.
    @IBInspectable var localizeKey: String {
        set (key) {
            title = key.localized
        }
        get {
            return title!
        }
    }
}

extension UIBarButtonItem {
    /// localization key that overwrites the title.
    @IBInspectable var localizeKey: String {
        set (key) {
            title = key.localized
        }
        get {
            return title!
        }
    }
}

extension UIViewController {
    /// localization key that overwrites the title.
    @IBInspectable var localizeTitle: String {
        set (key) {
            title = key.localized
        }
        get {
            return title!
        }
    }
}
