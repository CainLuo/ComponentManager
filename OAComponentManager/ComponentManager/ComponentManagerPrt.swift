//
//  ComponentManagerPrt.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

protocol ComponentManagerPrt: class {
    func canOpenURL(_ url: URL) -> Bool
    func connectToOpenURL(_ url: URL, parameters: Dictionary<String, Any>) -> UIViewController?
    func connectToHandle<T: Any>(_ prt: T.Type) -> Any?
}
