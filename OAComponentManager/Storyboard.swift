//
//  Storyboard.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/29.
//

import UIKit

enum Storyboard: String {
    case ModuleA
    case Main
    
    func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC else {
            fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)")
        }
        
        return vc
    }
    
    func instantiateRoot() -> UIViewController {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: Bundle.main)
            .instantiateInitialViewController() else {
            fatalError("Couldn't instantiate root from \(self.rawValue)")
        }
        
        return vc
    }
    
    static func instantiateName<VC: UIViewController>(name: String, identifier: String) -> VC {
        guard let vc = UIStoryboard(name: name, bundle: Bundle.main)
            .instantiateViewController(withIdentifier: identifier) as? VC else {
            fatalError("Couldn't instantiate \(identifier) from \(name)")
        }
        return vc
    }
}

extension UIViewController {
    static var defultNib: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
    
    static var storyboardIdentifier: String {
        return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
    }
}
