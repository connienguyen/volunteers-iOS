import Foundation
import UIKit

extension UITableView {
    /**
     Dequeues from the table a cell with with the same identifier as the name of the class specified in the identity.

     Example: let cell table.dequeue(indexPath) as MyCell

     - parameter for: The indexPath.
     - parameter entity: The Class.self that inherits from UITableViewCell.
     */
    func dequeue<T: UITableViewCell>(_ indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        return dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as! T
    }

    /**
 
     Example: tableView.register(cellType: MyCellFromASeparateNib.self)
    */
    func register<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: cellType.className)
    }
}
