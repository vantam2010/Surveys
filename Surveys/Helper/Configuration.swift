//
//  Configuration.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Configuration {
    static let baseUrl = "https://nimble-survey-api.herokuapp.com"
    static let username = "carlos@nimbl3.com"
    static let password = "antikera"
    static let hightResolutionImageConfig = "l"
    public static func getDomain() -> String {
        let URL = NSURL(string: self.baseUrl)
        guard let domain = URL?.host else { return "" }
        return domain
    }
}
