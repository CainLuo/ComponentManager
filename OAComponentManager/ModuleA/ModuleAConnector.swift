//
//  ModuleAConnector.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

class ModuleAConnector: NSObject {
    
    static let instance = ModuleAConnector()
    
    func register() {
        ComponentManager.register(self)
    }
}

// MARK: ComponentManagerPrt
extension ModuleAConnector: ComponentManagerPrt {
    func canOpenURL(_ url: URL) -> Bool {
        return url.host == "ModuleB"
    }
    
    func connectToOpenURL(_ url: URL, parameters: Dictionary<String, Any>) -> UIViewController? {
        let vc = ModuleAViewController.configureWith()
        return vc
    }
    
    func connectToHandle(_ prt: Protocol) -> Any? {
        return nil
    }
}
