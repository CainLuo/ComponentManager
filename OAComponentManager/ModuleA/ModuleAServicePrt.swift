//
//  ModuleAServicePrt.swift
//  OAComponentManager
//
//  Created by YYKJ0048 on 2020/11/30.
//

import Foundation

protocol ModuleAServiceProtocol {
    func show(_ message: String, cancel:@escaping(([String: Any]) -> Void), done:@escaping(([String: Any]) -> Void))
    func getItem(_ name: String, age: Int) -> ModuleAItemServiceProtocol
    func deliveAprotocol(_ item: ModuleAItemServiceProtocol)
}

protocol ModuleAItemServiceProtocol {
    var itemName: String { get set }
    var itemAge: Int { get set }
    
    func description() -> String
}
