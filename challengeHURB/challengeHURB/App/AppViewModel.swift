import UIKit

// ViewModel Interface
protocol AppViewModelType: class {
    func fetchHotels()
}

// ViewModel -> View Delegate
protocol AppViewModelViewDelegate: class {
    func didFetchHotels()
}

// ViewModel -> Coordinator Delegate
protocol AppViewModelCoordinatorDelegate: class {
    func onLoaded()
}

final class AppViewModel {
    
    // MARK: Properties
    weak var view: AppViewModelViewDelegate?
    weak var coordinator: AppViewModelCoordinatorDelegate?
    var dao: DAOProtocol?
    
    init(dao: DAOProtocol) {
        self.dao = dao
    }
}

// MARK: - AppViewModelType
extension AppViewModel: AppViewModelType {
    func fetchHotels() {
        dao?.fetchHotels(completion: { (hotels, errorMsg) in
            print(hotels)
        })
    }
}
