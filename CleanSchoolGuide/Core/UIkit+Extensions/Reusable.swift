//
//  Reusable.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
}

// FIXME: - when apply differable, remove below contents
extension UITableView {

    public func register(_ cell: (UITableViewCell & Reusable).Type) {
        register(cell, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

}

extension UICollectionView {

    public func register(_ cell: (UICollectionViewCell & Reusable).Type) {
        register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}
