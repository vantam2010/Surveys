//
//  AppDelegate.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupGlobalAppearance()
        return true
    }

    func setupGlobalAppearance() {
        UINavigationBar.appearance().tintColor = ThemeManager.color.text
        let attributes = [NSAttributedString.Key.foregroundColor: ThemeManager.color.text]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().barStyle = .black
        let image = UIImage.imageWithColor(tintColor: ThemeManager.color.main)
        UINavigationBar.appearance().setBackgroundImage(image, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(tintColor: ThemeManager.color.main)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}
