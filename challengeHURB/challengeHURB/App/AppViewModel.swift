import UIKit

// ViewModel Interface
protocol AppViewModelType: class {}

// ViewModel -> View Delegate
protocol AppViewModelViewDelegate: class { }

// ViewModel -> Coordinator Delegate
protocol AppViewModelCoordinatorDelegate: class {
    func onLoaded()
}

final class AppViewModel {
    
    // MARK: Properties
    weak var view: AppViewModelViewDelegate?
    weak var coordinator: AppViewModelCoordinatorDelegate?
}

// MARK: - AppViewModelType
extension AppViewModel: AppViewModelType {}
