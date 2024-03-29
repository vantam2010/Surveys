//
//  Array+Extension.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

// MARK: using this method to avoid out of index
extension Array {
    func getElement(_ index: Int) -> Element? {
        return (0 <= index && index < count ? self[index] : nil)
    }
}
