//
//  ThemeManager.swift
//  Surveys
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

public struct ThemeColor {
    public var text: UIColor = .white
    public var background: UIColor = .darkGray
    public var highlight: UIColor = .red
    public var main: UIColor = .black
}

public struct ThemeFontSize {
    public let title:CGFloat = 17
    public let body:CGFloat = 14
}

public struct ThemeManager {
    private static var themeColor: ThemeColor?
    private static var themeFontSize: ThemeFontSize?
    
    public static var color: ThemeColor {
        if let storedTheme = self.themeColor {
            return storedTheme
        } else {
            return ThemeColor()
        }
    }
    
    public static var fontSize: ThemeFontSize {
        if let storedTheme = self.themeFontSize {
            return storedTheme
        } else {
            return ThemeFontSize()
        }
    }
}
