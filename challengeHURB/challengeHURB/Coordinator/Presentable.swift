import Foundation
import UIKit

// MARK: Presentable Protocol
public protocol Presentable {
  func toPresentable() -> UIViewController
}

// MARK: UIViewController Implements Presentable Protocol
extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}
