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
        tintColor = text
    }
    
    func updateBackgroundColor() {
        backgroundColor = background
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        tintColor = text
        backgroundColor = background
    }
}
