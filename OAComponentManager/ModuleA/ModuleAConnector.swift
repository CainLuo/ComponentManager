//
//  ModuleAConnector.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

class ModuleAConnector: NSObject {
        
    static func instance() -> ModuleAConnector {
        let connector = ModuleAConnector()
        return connector
    }
    
    func register() {
        ComponentManager.register(self)
    }
}

// MARK: ComponentManagerPrt
extension ModuleAConnector: ComponentManagerPrt {
    func canOpenURL(_ url: URL) -> Bool {
        return url.host == "ModuleB"
    }
    
    func connectToOpenURL(_ url: URL, parameters: Dictionary<String, Any>?, completion: (([String : Any]) -> Void)?) -> UIViewController? {
        guard canOpenURL(url) else { return nil }
        
        let vc = ModuleAViewController.configureWith()
        return vc
    }
}

extension ModuleAConnector: ModuleAServiceProtocol {
    func show(_ message: String, cancel: @escaping (([String : Any]) -> Void), done: @escaping (([String : Any]) -> Void)) {
        let cancel = UIAlertAction(title: "取消", style: .cancel) { action in
            cancel(["alertAction":action])
        }
        
        let done = UIAlertAction(title: "确定", style: .default) { action in
            done(["alertAction":action])
        }
        
        let alert = UIAlertController(title: "ModuleA", message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(done)
        
        if let window = UIApplication.shared.windows.first,
           let root = window.rootViewController {
            root.present(alert, animated: true, completion: nil)
        }
    }
    
    func getItem(_ name: String, age: Int) -> ModuleAItemServiceProtocol {
        let item = ModuleAItem()
        item.itemName = "AAAAAAAAA"
        item.itemAge = 1000
        return item
    }
    
    func deliveAprotocol(_ item: ModuleAItemServiceProtocol) {
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in }
        let done = UIAlertAction(title: "取消", style: .default) { _ in }
        let message = item.description()
        let alert = UIAlertController(title: "ModuleA", message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(done)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
