import UIKit

typealias LaunchOptionsType = [UIApplication.LaunchOptionsKey: Any]

// MARK: Application
@UIApplicationMain
class AppDelegate: UIResponder {
    
    // MARK: Application Properties
    var orientation = UIInterfaceOrientationMask.portrait
    
    // Application Main Window
    var window: UIWindow?
    
    // Application Coordinator Router (Navigation Controller)
    lazy var coordinatorRouter: CoordinatorRouterType = CoordinatorRouter()
    
    // Application Coordinator
    var coordinator: Coordinator?
    
}

// MARK: - Application Extension
extension AppDelegate: UIApplicationDelegate {
    
    // MARK: Application Delegate Methods
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: LaunchOptionsType?) -> Bool {
        setupRootCoordinator()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
    private func setupRootCoordinator() {
        coordinator = AppCoordinator(router: coordinatorRouter)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.router.navigationController
        window?.makeKeyAndVisible()
        coordinator?.start()
    }
}
