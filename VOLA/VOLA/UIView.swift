import Foundation
import UIKit

extension UIView {

    /// Sets corner radius. Specify half width to make a full circle.
    /// Applies shouldRasterize as true for prevention, set it to false when animating (causing each frame to be re-rendering)
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0

            //performance, test required
            layer.shouldRasterize = newValue > 0
            layer.rasterizationScale = UIScreen.main.scale
        }
    }

    /// Border width.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }

        set(value) {
            layer.borderWidth = value
        }
    }

    /// Border color.
    @IBInspectable var borderColor: UIColor? {
        get {
            if let layerBorderColor = layer.borderColor {
                return UIColor(cgColor: layerBorderColor)
            }
            return nil
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }

    /// Shadow color of view.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// Shadow offset of view.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// Shadow opacity of view.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// Shadow radius of view.
    /// Applies shouldRasterize as true for prevention, set it to false when animating (causing each frame to be re-rendering)
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = newValue <= 0
            layer.shadowRadius = newValue

            //performance, test required
            layer.shouldRasterize = newValue > 0
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
}

extension UIView {

    var screenshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func pin(on view: UIView, given directions: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing], constants: [CGFloat] = [0, 0, 0, 0]) {
        view.addSubview(self)
        for i in 0...directions.count - 1 {
            let direction = directions[i]
            let constant = constants[i]
            let contraint = NSLayoutConstraint(item: self, attribute: direction, relatedBy: .equal, toItem: view, attribute: direction, multiplier: 1,
                                               constant: constant)
            view.addConstraint(contraint)
        }
    }
    
    func limitSize(width: CGFloat, height: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                         constant: width))
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                         constant: height))
    }
}

extension UIView {

    /**
     Triggers blink animation  in a view with a duration.

     - parameter duration: custom animation duration (defaults 0.2).
     */
    func blink(withDuration duration: TimeInterval = 0.2) {
        alpha = 0
        fadeIn(duration: duration, originalOpacity: alpha)
    }

    /**
     Fade in a view with a duration.

     - parameter duration: custom animation duration (defaults 0.5).
     - parameter completion: completion block that will be executed after the animation finished.
     */
    func fadeIn(duration: TimeInterval = 0.5, originalOpacity: CGFloat = 1, completion: ((Bool) -> Void)? = nil) {
        isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /**
     Fade out a view with a duration.

     - parameter duration: custom animation duration.
     - parameter completion: completion block that will be executed after the animation finished.
     */
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        isHidden = false

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }

    func addTapGesture(tapNumber: Int = 1, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true        
    }
    
    func addGradient(with colors: CGColor...) {
        layoutIfNeeded()
        
        let gradient = CAGradientLayer()
        gradient.cornerRadius = cornerRadius
        gradient.frame.size = bounds.size
        gradient.frame.origin = CGPoint.zero
        gradient.colors = colors
        
        layer.insertSublayer(gradient, at: 0)
    }
}
