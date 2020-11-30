//
//  ModuleAItem.swift
//  OAComponentManager
//
//  Created by YYKJ0048 on 2020/11/30.
//

import Foundation

class ModuleAItem: ModuleAItemServiceProtocol {
    var itemName: String = ""
    var itemAge: Int = 0
    
    func description() -> String {
        return "Module: ItemName: \(itemName), itemAge = \(itemAge)"
    }
}
