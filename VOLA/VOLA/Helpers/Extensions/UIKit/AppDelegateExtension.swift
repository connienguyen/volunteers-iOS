import Foundation
import UIKit

extension AppDelegate {

    /**
     Change root view animated

     - parameter targetView: The final `UIViewController`.
     - parameter duration:
     */
    class func replaceWindowAnimated(targetView: UIViewController, duration: TimeInterval = 0.65) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            Logger.warn("Couldn't get app delegate")
            return
        }

        UIView.transition(from: (app.window?.rootViewController!.view)!, to: targetView.view, duration: duration, options: .transitionCrossDissolve,
                          completion: { _ in app.window?.rootViewController = targetView })
    }
}
