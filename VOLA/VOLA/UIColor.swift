import Foundation
import UIKit

extension UIColor {

    /**
     Initializes a color with a custom hex specification.
     Usage: UIColor(hex: 0x222222) //for grey.

     - parameter hex: The HEX code.
     */
    convenience init(hex: UInt) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(hex & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0)
        )
    }

    /// Red component of UIColor.
    var redComponent: Int {
        var red: CGFloat = 0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return Int(red * 255)
    }

    /// Green component of UIColor.
    var greenComponent: Int {
        var green: CGFloat = 0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return Int(green * 255)
    }

    /// blue component of UIColor.
    var blueComponent: Int {
        var blue: CGFloat = 0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return Int(blue * 255)
    }

    /// Alpha of UIColor.
    var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
}
