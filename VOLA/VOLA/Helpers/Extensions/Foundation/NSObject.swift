import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }

    /// Adds an NotificationCenter with name and Selector
    func addNotificationObserver(_ name: NSNotification.Name, selector: Selector, _ object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }

    /// Removes an NSNotificationCenter for name
    func removeNotificationObserver(_ name: NSNotification.Name, _ object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
    }

    /// Removes NotificationCenter'd observer
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
