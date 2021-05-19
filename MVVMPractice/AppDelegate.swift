//
//  AppDelegate.swift
//  MVVMPractice
//
//  Created by 肥沼英里 on 2021/05/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Router.shared.showRoot(window: UIWindow(frame: UIScreen.main.bounds))
        return true
    }
}

