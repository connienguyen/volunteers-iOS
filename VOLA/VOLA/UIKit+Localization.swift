import Foundation
import UIKit

/**
 Returns localized string with the id given by the key

 - Parameter key: localization key
 - Parameter comment: optional comment

 */
func localize(_ key: String, _ comment: String = "") -> String {
    return NSLocalizedString(key, comment: comment)
}

extension UILabel {
    /// localization key that will overwrite the label text.
    @IBInspectable var localizeKey: String {
        set (key) {
            text = localize(key)
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
            setTitle(localize(key), for: .normal)
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
            title = localize(key)
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
            title = localize(key)
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
            title = localize(key)
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
            title = localize(key)
        }
        get {
            return title!
        }
    }
}
