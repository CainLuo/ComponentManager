//
//  AppDelegate.swift
//  OAComponentManager
//
//  Created by CainLuo on 2020/11/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ModuleAConnector.instance.register()
        
        let tabBar = UITabBarController()
        
        let vc1 = ViewController.configureWith()
        let nav1 = UINavigationController(rootViewController: vc1)
        
        vc1.title = "A"
        vc1.view.backgroundColor = .red
        
        var nav2: UINavigationController!
        if let vc2 = ComponentManager.viewControllerForURL(URL(string: "productScheme://ModuleB")!) {
            vc2.title = "vc2"
            nav2 = UINavigationController(rootViewController: vc2)
        }
        let vc3 = ViewController()
        vc3.title = "vc3"
        vc3.view.backgroundColor = .yellow
        let nav3 = UINavigationController(rootViewController: vc3)

        tabBar.viewControllers = [nav1, nav2, nav3]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        return true
    }
}

