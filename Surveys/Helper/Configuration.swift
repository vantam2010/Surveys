//
//  Configuration.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Configuration {
    static let BASE_URL = "https://nimble-survey-api.herokuapp.com"
    static let USER_NAME = "carlos@nimbl3.com"
    static let PASSWORD = "antikera"
    static let HIGH_RESOLUTION_IMAGE_CONFIG = "l"
    
    public static func getDomain() -> String {
        let URL = NSURL(string: self.BASE_URL)
        guard let domain = URL?.host else { return "" }
        return domain
    }
}
