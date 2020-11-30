//
//  ComponentManager.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

let routerModeKey = "routerModeKey"
let routeViewControllerKey = "routeViewControllerKey"

private var connectorMap: [String: ComponentManagerPrt] = [:]

class ComponentManager {
    
    /// 向控制中心注册连接点
    /// - Parameter object: 遵循了ComponentManagerPrt协议的类
    static func register(_ object: ComponentManagerPrt) {
        let keys = [String](connectorMap.keys)
        let classString = String(describing: object.self)
        if !keys.contains(classString) {
            connectorMap.updateValue(object, forKey: classString)
        }
    }
    
    /// 判断某个URL能否导航
    /// - Parameter url: URL
    /// - Returns: Bool
    static func canRouteURL(_ url: URL) -> Bool {
        if connectorMap.isEmpty { return false }
        return connectorMap.map { $0.value.canOpenURL(url) }.first ?? false
    }
    
    /// 通过URL完成页面跳转
    /// - Parameters:
    ///   - url: URL地址
    ///   - parameters: 需要传参的Dictionary
    /// - Returns: Bool, true or false
    static func routeURL(_ url: URL, parameters: Dictionary<String, Any>? = nil) -> Bool {
        if connectorMap.isEmpty { return false }

        var isSuccess = false
        var queryCount = 0
        let userParameters: [String: Any] = [:]
        connectorMap.forEach { (key, value) in
            queryCount += 1
            let vc = value.connectToOpenURL(url, parameters: userParameters, completion: nil)
            
            if let vc = vc, vc.isKind(of: UIViewController.self) {
                if vc.isKind(of: ErrorTipViewController.self) {
                    let errorTipVC = vc as! ErrorTipViewController
                    
                    if errorTipVC.isNotURLSupport {
                        isSuccess = true
                    } else {
                        isSuccess = false
                        
                        #if DEBUG
                        // Show Debug
                        #endif
                    }
                    
                } else if checkViewController(vc.className) {
                    isSuccess = true
                } else {
                    
                    // Navigation push
//                    if let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController,
//                       let nav = tab.viewControllers?.first as? UINavigationController {
//                        nav.pushViewController(vc, animated: true)
//                    }
                    
                    if let parameters = parameters {
                        Navigator.instance().showURL(vc, base: parameters[routeViewControllerKey] as? UIViewController,
                                                     routerType: (parameters[routerModeKey] != nil) ? parameters[routerModeKey] as! NavigatorType : .push)
                    }
                    isSuccess = true
                }
                return
            }
        }
        
        #if DEBUG
        if !isSuccess && queryCount == connectorMap.count {
            // Show Debug
            return false
        }
        #endif
        
        return isSuccess
    }

    /// 通过URL获取UIViewController的实例类
    /// - Parameters:
    ///   - url: URL地址
    ///   - parameters: 需要传参的Dictionary参数
    /// - Returns: UIViewController
    static func viewControllerForURL(_ url: URL, parameters: Dictionary<String, Any>? = nil) -> UIViewController? {
        if connectorMap.isEmpty { return nil }

        var vc: UIViewController?
        var queryCount = 0
        guard let parameters = self.userParameters(url, parameters: parameters) else { return nil }
        
        connectorMap.forEach { (key, value) in
            queryCount += 1
            vc = value.connectToOpenURL(url, parameters: parameters, completion: nil)
            if let resultVC = vc,
                resultVC.isKind(of: UIViewController.self) {
                return
            }
        }
        
        #if DEBUG
        if vc != nil && queryCount == connectorMap.count {
            // Show Debug
        }
        #endif
        
        if let vc = vc {
            if vc.isKind(of: ErrorTipViewController.self) {
                #if DEBUG
                // Show Debug
                #endif
                return nil
            } else if checkViewController(vc.className) {
                return nil
            } else {
                return vc
            }
        }
        
        return nil
    }
    
    /// 服务调用接口
    /// - Parameter prt: ComponentManagerPrt
    /// - Returns: Any
//    static func serviceForProtocol<T: Any>(_ prt: T.Type) -> T? {
//        guard !connectorMap.isEmpty else { return nil }
//        if let results = connectorMap.map({ $0.value.connectToHandle(prt) }).filter({ $0 != nil }).first,
//           return results
//        }
//        return nil
//    }
    
    /// Private Methos
    /// - Parameter vcName: UIViewController class name
    /// - Returns: Bool
    private static func checkViewController(_ vcName: String) -> Bool {
        return vcName.components(separatedBy: ".").last == "UIViewController"
    }
}

extension ComponentManager {
    
    /// 获取URL中的拼接参数
    /// - Parameters:
    ///   - url: URL
    ///   - parameters: Dictionary<String, Any>
    /// - Returns: Dictionary<String, Any>
    static func userParameters(_ url: URL, parameters: [String: Any]?) -> [String: Any]? {
        guard parameters == nil else { return nil }
        
        var parameters: [String: Any] = [:]
        if let items = URLComponents(string: url.absoluteString)?.queryItems {
            items.forEach({ item in
                if let value = item.value {
                    parameters.updateValue(value, forKey: item.name)
                }
            })
        }
                
        return parameters
    }
}

extension NSObject {
    fileprivate class var className: String {
        return String(describing: self)
    }
    
    fileprivate var className: String {
        return type(of: self).className
    }
}
