//
//  UIColor+Extension.swift
//  Surveys
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt: UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        var red: UInt32?, green: UInt32?, blue: UInt32?
        switch hexWithoutSymbol.count {
        case 3: // #RGB
            red = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            green = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            blue = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
        case 6: // #RRGGBB
            red = (hexInt >> 16) & 0xff
            green = (hexInt >> 8) & 0xff
            blue = hexInt & 0xff
        default:
            break
        }
        guard let redValue = red, let greenValue = green, let blueValue = blue else {
            self.init()
            return
        }
        self.init(
            red: (CGFloat(redValue)/255),
            green: (CGFloat(greenValue)/255),
            blue: (CGFloat(blueValue)/255),
            alpha: alpha)
    }
}
