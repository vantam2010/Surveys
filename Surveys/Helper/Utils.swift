//
//  Utils.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

public class Utils {
    public static func visibleViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate
        if let window = appDelegate?.window {
            return window?.visibleViewController
        }
        return nil
    }
}
