import Foundation
import UIKit

extension UITableView {
    /**
     Dequeues from the table a cell with with the same identifier as the name of the class specified in the identity.

     - parameter for: The indexPath.
     - parameter entity: The Class.self that inherits from UITableViewCell.
     */
    func dequeue<T: UITableViewCell>(_ indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        return dequeueReusableCell(withIdentifier: cellType.className, for: indexPath) as! T
    }

    func register<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: cellType.className)
    }

    func allCells(in section: Int) -> [UITableViewCell] {
        var result = [UITableViewCell]()
        if numberOfRows(inSection: section) > 0 {
            for i in 0...(numberOfRows(inSection: section) - 1) {
                result.append(cellForRow(at: IndexPath(row: i, section: section))!)
            }
        }

        return result
    }
}
