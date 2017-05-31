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
}
