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
        _ = ComponentManager.routeURL(ModuleRouter.moduleA,
                                      parameters: [routerModeKey: NavigatorType.present],
                                      completion: { info in
            print("done: -------------------------------------:\(info)")
        })
        
//        let prt = ComponentManager.serviceForProtocol(ModuleAServiceProtocol.self) as? ModuleAConnector
//        prt?.show("gagga", cancel: { info in
//            print("cancel: -------------------------------------:\(info)")
//        }, done: { info in
//            print("done: -------------------------------------:\(info)")
//        })
    }
}

enum ModuleRouter {
    static let moduleA = URL(string: "productScheme://ModuleAAAAAA")!
}
