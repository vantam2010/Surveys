//
//  NotificationManager.swift
//  Surveys
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

public struct NotificationManager {
    static let shared = NotificationManager()
    
    private init(){}
    
    public func showError(_ message: String, title: String? = nil, viewController: UIViewController? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        if let viewController = viewController {
            viewController.present(alertController, animated: true)
        } else {
            Utils.visibleViewController()?.present(alertController, animated: true)
        }
    }
}
