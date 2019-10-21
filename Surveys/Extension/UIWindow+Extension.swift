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
        return UIWindow.visibleVC(vc: self.rootViewController)
    }
    
    static func visibleVC(vc: UIViewController?) -> UIViewController? {
        if let navigationViewController = vc as? UINavigationController {
            return UIWindow.visibleVC(vc: navigationViewController.visibleViewController)
        } else if let tabBarVC = vc as? UITabBarController {
            return UIWindow.visibleVC(vc: tabBarVC.selectedViewController)
        } else {
            if let presentedVC = vc?.presentedViewController {
                return UIWindow.visibleVC(vc: presentedVC)
            } else {
                return vc
            }
        }
    }
}
