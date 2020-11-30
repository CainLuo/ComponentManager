//
//  ViewController.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

class ViewController: UIViewController {

    static func configureWith() -> ViewController {
        let vc = Storyboard.Main.instantiate(ViewController.self)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pushToModuleA(_ sender: Any) {
        _ = ComponentManager.routeURL(URL(string: "productScheme://ModuleB")!, parameters: [routerModeKey: NavigatorType.present])
    }
}

