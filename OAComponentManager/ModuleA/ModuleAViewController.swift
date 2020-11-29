//
//  ModuleAViewController.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

class ModuleAViewController: UIViewController {
    
    static func configureWith() -> ModuleAViewController {
        let vc = Storyboard.ModuleA.instantiate(ModuleAViewController.self)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ModuleA"
        
        view.backgroundColor = .black
    }    
}
