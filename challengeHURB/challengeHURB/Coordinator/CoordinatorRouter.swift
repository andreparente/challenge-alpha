import UIKit

// MARK: Coordinator Router Interface
public protocol CoordinatorRouterType: class, Presentable {
    
    // MARK: Coordinator Router Interface Properties
    typealias Completion = (() -> Void)
    
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }

    // MARK: Coordinator Router Interface Methods
    func present(module: Presentable)
    func present(module: Presentable, animated: Bool)
    func present(module: Presentable, animated: Bool, onPresented: Completion?)
    
    func dismiss()
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, onDismissed: Completion?)
    
    func push(module: Presentable)
    func push(module: Presentable, animated: Bool)
    
    func replaceTo(module: Presentable)
    
    func pop()
    func pop(animated: Bool)
    
    func setToRoot(module: Presentable)
    func setToRoot(module: Presentable, animated: Bool)
    func setToRoot(module: Presentable, animated: Bool, hideBar: Bool)
    
    func popToRoot()
    func popToRoot(animated: Bool)
}

// MARK: Coordinator Router
public class CoordinatorRouter: NSObject {
    
    // MARK: Coordinator Router Properties
    private var _navigationController: UINavigationController
    private var _duringAnimation: Bool = false
    
    public init(navigationController: UINavigationController = UINavigationController()) {
        _navigationController = navigationController
        super.init()
        _navigationController.delegate = self
        _navigationController.interactivePopGestureRecognizer?.delegate = self
        _navigationController.navigationBar.isTranslucent = false
    }
}

// MARK: Coordinator Router Extension Implement Coordinator Router Interface
extension CoordinatorRouter: CoordinatorRouterType {
    // MARK: Coordinator Router Interface Properties
    public var navigationController: UINavigationController { _navigationController }
    
    public var rootViewController: UIViewController? {
        if let presentedViewController = _navigationController.presentedViewController {
            return presentedViewController
        } else if let topViewController = _navigationController.topViewController {
            return topViewController
        } else {
            return _navigationController
        }
    }
    
    // MARK: Coordinator Router Interface Methods
    public func present(module: Presentable) {
        present(module: module, animated: true)
    }
    
    public func present(module: Presentable, animated: Bool) {
        present(module: module, animated: animated, onPresented: nil)
    }
    
    public func present(module: Presentable, animated: Bool, onPresented: Completion?) {
        guard !_duringAnimation else { return }
        
        _duringAnimation = true
        
        DispatchQueue.main.async {
            self.rootViewController?.present(module.toPresentable(),
                                             animated: animated) { [weak self] in
                onPresented?()
                self?._duringAnimation = false
            }
        }
    }

    public func dismiss() {
        dismiss(animated: true)
    }
    
    public func dismiss(animated: Bool) {
        dismiss(animated: animated, onDismissed: nil)
    }
    
    public func dismiss(animated: Bool, onDismissed: Completion?) {
        DispatchQueue.main.async {
            self.rootViewController?.dismiss(animated: animated, completion: onDismissed)
        }
    }
    
    public func push(module: Presentable) {
        push(module: module, animated: true)
    }
    
    public func push(module: Presentable, animated: Bool) {
        guard !_duringAnimation else { return }
        
        let controller = module.toPresentable()
        
        guard !(controller is UINavigationController) else { return }
        
        DispatchQueue.main.async {
            self._duringAnimation = true
            self._navigationController.pushViewController(controller, animated: animated)
        }
    }
    
    public func replaceTo(module: Presentable) {
        pop(animated: false)
        push(module: module, animated: false)
    }
    
    public func pop() {
        pop(animated: true)
    }
    
    public func pop(animated: Bool) {
        DispatchQueue.main.async {
            self._navigationController.popViewController(animated: animated)
        }
    }
    
    public func setToRoot(module: Presentable) {
        setToRoot(module: module, animated: true)
    }
    
    public func setToRoot(module: Presentable, animated: Bool) {
        setToRoot(module: module, animated: animated, hideBar: false)
    }
    
    public func setToRoot(module: Presentable, animated: Bool, hideBar: Bool) {
        
        let controller = module.toPresentable()
        
        _navigationController.setViewControllers([controller], animated: animated)
        _navigationController.isNavigationBarHidden = hideBar
    }
    
    public func popToRoot() {
        popToRoot(animated: true)
    }
    
    public func popToRoot(animated: Bool) {
        self._navigationController.popToRootViewController(animated: animated)
    }

    public func toPresentable() -> UIViewController { navigationController }
}

// MARK: Coordinator Router Extension Implement Navigation Controller Delegate
extension CoordinatorRouter: UINavigationControllerDelegate {
    
    // MARK: Navigation Controller Delegate Methods
    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        _duringAnimation = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CoordinatorRouter: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == _navigationController.interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return _navigationController.viewControllers.count > 1 && _duringAnimation == false
    }
}
