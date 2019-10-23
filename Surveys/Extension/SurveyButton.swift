//
//  SurveyButton.swift
//  Surveys
//
//  Created by Apple on 10/24/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

@IBDesignable
class SurveyButton: UIButton {
    
    @IBInspectable var text: UIColor = ThemeManager.color.text { didSet { updatTextColor() }}
    @IBInspectable var background: UIColor = ThemeManager.color.highlight { didSet { updateBackgroundColor() }}
    
    func updatTextColor() {
        self.tintColor = tintColor
    }
    
    func updateBackgroundColor() {
        self.backgroundColor = background
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height/2
        self.tintColor = tintColor
        self.backgroundColor = background
    }
}
