//
//  ThemeManager.swift
//  Surveys
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

struct ThemeColor {
    let text: UIColor = .white
    let background: UIColor = .darkGray
    let highlight: UIColor = UIColor.init(hex: "D02424")
    let main: UIColor = .black
}

struct ThemeFontSize {
    let title: CGFloat = 17
    let body: CGFloat = 14
}

struct ThemeManager {
    private static var themeColor: ThemeColor?
    private static var themeFontSize: ThemeFontSize?
    static var color: ThemeColor {
        if let storedTheme = themeColor {
            return storedTheme
        } else {
            return ThemeColor()
        }
    }
    static var fontSize: ThemeFontSize {
        if let storedTheme = themeFontSize {
            return storedTheme
        } else {
            return ThemeFontSize()
        }
    }
}
