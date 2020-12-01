//
//  ComponentManagerPrt.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

protocol ComponentManagerPrt: class {
    /// 判断输入的URL是否能响应
    /// - Parameter url: URL, 比如: URL(string: "productScheme://XXXXXX")
    func canOpenURL(_ url: URL) -> Bool
    
    /// 获取对应URL的UIViewController实例
    /// - Parameters:
    ///   - url: URL, 比如: URL(string: "productScheme://XXXXXX")
    ///   - parameters: Dictionary, 传参到UIViewController实例
    ///   - completion: completion, UIViewController实例的回调
    func connectToOpenURL(_ url: URL, parameters: Dictionary<String, Any>?, completion: (([String: Any]) -> Void)?) -> UIViewController?
}
