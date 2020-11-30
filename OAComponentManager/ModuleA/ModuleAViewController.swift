//
//  ModuleAViewController.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

class ModuleAViewController: UIViewController {
    
    var completion: (([String : Any]) -> Void)?
    
    static func configureWith() -> ModuleAViewController {
        let vc = Storyboard.ModuleA.instantiate(ModuleAViewController.self)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ModuleA"
        
        view.backgroundColor = .black
    }
    
    @IBAction func tapAction(_ sender: Any) {
        if let completion = completion {
            completion(["ModuleAViewController": 123123123])
        }
    }
}
