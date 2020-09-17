import Foundation
import UIKit

public protocol CoordinatorDelegate: class {
    func onCoordinatorFinish(_ coordinator: Coordinator?)
}

public extension CoordinatorDelegate where Self: Coordinator {
    func onCoordinatorFinish(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else { return }
        removeChild(coordinator)
    }
}

// MARK: Coordinator Protocol
public protocol Coordinator: class {
    
    // MARK: Coordinator Properties
    
    /// Strong Reference to Child Coordinators
    var childCoordinators: [Coordinator] { get set }
    
    /// Reference of Coordinator Router (Navigation Controller)
    var router: CoordinatorRouterType { get set }
    
    /// Delegate to respond to parentCoordinator. This property is always WEAK!
    var coordinatorDelegate: CoordinatorDelegate? { get set }
    
    /// Coordinator Flow Starter
    func start()

    func loadViewController() -> UIViewController    
}

// MARK: Coordinator Protocol Extension
public extension Coordinator {
    
    /// Add Coordinator to childs
    func addChild(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator }) {
            childCoordinators.append(coordinator)
        }
        
        if let delegate = self as? CoordinatorDelegate {
            coordinator.coordinatorDelegate = delegate
        }
    }
    
    /// Remove Coordinator from childs
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
