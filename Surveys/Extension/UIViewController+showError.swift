//
//  UIViewController+AlertMessage.swift
//  Surveys
//
//  Created by Apple on 10/31/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
