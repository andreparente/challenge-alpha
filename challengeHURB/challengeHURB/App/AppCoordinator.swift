import UIKit

protocol AppCoordinatorDelegate: class { }

final class AppCoordinator: Coordinator {
    
    // MARK: Properties
    var childCoordinators: [Coordinator] = []
    weak var coordinatorDelegate: CoordinatorDelegate?
    
    var router: CoordinatorRouterType
    
    // MARK: Initializers
    init(router: CoordinatorRouterType) {
        self.router = router
    }
    
    // MARK: Methods
    func start() {
        let module = loadViewController()
        router.setToRoot(module: module, animated: false, hideBar: true)
    }
    
    func loadViewController() -> UIViewController {
    
        let viewModel = AppViewModel()
        let viewController = AppViewController(viewModel: viewModel)
        
        viewModel.coordinator = self
        viewModel.view = viewController
        
        viewController.viewModel = viewModel
        
        return viewController
        
    }
}

// MARK: - AppViewModelCoordinatorDelegate
extension AppCoordinator: AppViewModelCoordinatorDelegate {
    func onLoaded() {}
}
