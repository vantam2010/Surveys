//
//  UIWindow+Extension.swift
//  Surveys
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.visibleVC(controller: self.rootViewController)
    }
    static func visibleVC(controller: UIViewController?) -> UIViewController? {
        if let navigationViewController = controller as? UINavigationController {
            return UIWindow.visibleVC(controller: navigationViewController.visibleViewController)
        } else if let tabBarVC = controller as? UITabBarController {
            return UIWindow.visibleVC(controller: tabBarVC.selectedViewController)
        } else {
            if let presentedVC = controller?.presentedViewController {
                return UIWindow.visibleVC(controller: presentedVC)
            } else {
                return controller
            }
        }
    }
}
