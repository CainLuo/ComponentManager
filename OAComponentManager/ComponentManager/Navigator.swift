//
//  Navigator.swift
//  OAComponentManager
//
//  Created by YYKJ0048 on 2020/11/30.
//

import UIKit

enum NavigatorType {
    case none
    case push       // push a viewController in NavigationController
    case present    // present a viewController in NavigationController
    case popTo      // pop to the viewController already in NavigationController or tabBarController
}

enum NavigatorScreenType {
    case normal
    case fullScreen // present full secreen
}

fileprivate typealias navigatorRouterBlock = (_ vc: UIViewController, _ base: UIViewController, _ routerType: NavigatorType, _ screenType: NavigatorScreenType) -> Bool

class Navigator {
    
    static func instance() -> Navigator {
        let navi = Navigator()
        navi.routeBlock = nil
        return navi
    }
    
    private var routeBlock: navigatorRouterBlock?
    
    
    /// 拦截跳转方式
    /// - Parameter completion: (_ vc: UIViewController, _ base: UIViewController, _ routerType: NavigatorType) -> Bool
    func hockRouter(completion: @escaping(UIViewController, UIViewController, NavigatorType, NavigatorScreenType) -> Bool) {
        routeBlock = completion
    }
    
    /// 在BaseViewController下展示URL对应的Controller
    /// - Parameters:
    ///   - vc: UIViewController, 当前需要Present的Controller
    ///   - base: UIViewController, 展示的BaseViewController
    ///   - routerType: NavigatorType, 跳转方式
    func showURL(_ vc: UIViewController, base: UIViewController?, routerType: NavigatorType, screenType: NavigatorScreenType = .normal) {
        switch routerType {
        case .push, .none:
            push(vc, base: base)
        case .popTo:
            popTo(vc, base: base)
        case .present:
            present(vc, base: base)
        }
    }
}

// MARK: Push Type Methods
extension Navigator {
    func push(_ vc: UIViewController, base: UIViewController?) {
        var base = base
        if base == nil {
            base = topViewController()
        }
        
        guard let baseVC = base else { return }
        
        if let navi = baseVC as? UINavigationController {
            navi.pushViewController(vc, animated: true)
        } else if let navi = baseVC.navigationController {
            navi.pushViewController(vc, animated: true)
        } else {
            let navi = UINavigationController(rootViewController: vc)
            baseVC.present(navi, animated: true, completion: nil)
        }
    }
}

// MARK: Present Type Methods
extension Navigator {
    func present(_ vc: UIViewController, base: UIViewController?) {
        var base = base
        if base == nil {
            base = topViewController()
        }

        if let base = base,
           base.isKind(of: UITabBarController.self) ||
            base.isKind(of: UINavigationController.self) {
            return
        }
        
        if let base = base,
           base.presentedViewController != nil {
            base.dismiss(animated: true, completion: nil)
        }
        let navi = UINavigationController(rootViewController: vc)
        base?.present(navi, animated: true, completion: nil)
    }
}

// MARK: Pop To Type Methods
extension Navigator {
    func popTo(_ vc: UIViewController, base: UIViewController?) {
        guard let root = UIApplication.shared.windows.first?.rootViewController else { return }
        
        if let tabBar = root as? UITabBarController, let vcs = tabBar.viewControllers {
            var selectIndex = -1
            for tempVC in vcs  {
                if let navi = tempVC as? UINavigationController {
                    if popTo(vc, navi: navi) {
                        selectIndex = vcs.firstIndex(of: navi) ?? -1
                        break
                    }
                } else {
                    if tempVC == vc {
                        selectIndex = vcs.firstIndex(of: tempVC) ?? -1
                        break
                    }
                }
            }
            
            if let delegate = tabBar.delegate,
               delegate.responds(to: #selector(UITabBarControllerDelegate.tabBarController(_:shouldSelect:))) {
                _ = delegate.tabBarController?(tabBar, shouldSelect: vcs[selectIndex])
            }
            
        } else if let navi = root as? UINavigationController {
            _ = popTo(vc, navi: navi)
        } else {
            if vc != root {
                let navi = UINavigationController(rootViewController: vc)
                root.present(navi, animated: true, completion: nil)
            }
        }
    }
    
    func popTo(_ vc: UIViewController, navi: UINavigationController) -> Bool {
        
        let count = navi.viewControllers.count
        if count == 0 { return false }
        var success = false
        
        for tempVC in navi.viewControllers {
            
            if tempVC.presentedViewController != nil {
                if let tempNavi = tempVC.presentedViewController as? UINavigationController,
                   popTo(vc, navi: tempNavi) {
                    navi.popToViewController(tempVC, animated: true)
                    success = true
                    break
                } else {
                    if tempVC.presentedViewController == vc {
                        navi.popToViewController(tempVC, animated: true)
                        success = true
                        break
                    }
                }
            } else {
                if tempVC == vc {
                    navi.popToViewController(tempVC, animated: true)
                    success = true
                    break
                }
            }
        }
        
        return success
    }
}

// MARK: 外部不能调用该类别中的方法，仅供Busmediator中调用
extension Navigator {
    func hookURL(_ vc: UIViewController, base: UIViewController, routerType: NavigatorType, screenType: NavigatorScreenType = .normal) {
        var success = false
        if let routeBlock = routeBlock {
            success = routeBlock(vc, base, routerType, screenType)
        }
        
        if !success {
            showURL(vc, base: base, routerType: routerType, screenType: screenType)
        }
    }
}

extension Navigator {
    private func topViewController() -> UIViewController? {
        guard var window = UIApplication.shared.windows.first else { return nil }
        
        if window.windowLevel != .normal {
            let windows = UIApplication.shared.windows
            for normalWindow in windows {
                if normalWindow.windowLevel == .normal {
                    window = normalWindow
                    break
                }
            }
        }
        
        var result = window.rootViewController
            
        while result?.presentedViewController != nil {
            result = result?.presentedViewController
        }
        
        if let tabBarController = result as? UITabBarController {
            result = tabBarController.selectedViewController
        }

        if let navigationController = result as? UINavigationController {
            result = navigationController.topViewController
        }

        return result
    }
}
