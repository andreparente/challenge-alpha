import UIKit

final class AppViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // Strong Reference to ViewModel Interface
    var viewModel: AppViewModelType
    
    // MARK: Initializers
    
    // Custom ViewController Initializer with Instance of ViewModel
    init(viewModel: AppViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: AppViewController.self), bundle: nil)
    }
    
    // Required Initialize with Decoder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchHotels()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: String(describing: HotelTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: String(describing: HotelTableViewCell.self))
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: - AppViewModelViewDelegate
extension AppViewController: AppViewModelViewDelegate { }
