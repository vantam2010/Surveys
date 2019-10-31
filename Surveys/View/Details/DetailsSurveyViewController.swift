//
//  DetailsSurveyViewController.swift
//  Surveys
//
//  Created by Apple on 10/24/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

class DetailsSurveyViewController: UIViewController {
    
    var survey: Survey? {
        didSet {
            title = survey?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.color.background
    }
}
