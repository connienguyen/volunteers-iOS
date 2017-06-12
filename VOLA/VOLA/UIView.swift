import Foundation
import UIKit

extension UIView {

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
            guard let layerBorderColor = layer.borderColor  else {
                return nil
            }
            return UIColor(cgColor: layerBorderColor)
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

protocol XIBInstantiable {
    static var associatedNib: UINib { get }
}

extension XIBInstantiable {
    static var associatedNib: UINib {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle.main)
    }

    static func instantiateFromXib() -> Self {
        guard let view =  associatedNib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load from nib.")
        }

        return view
    }
}
