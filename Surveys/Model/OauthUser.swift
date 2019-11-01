//
//  OauthUser.swift
//  Surveys
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct OauthUser: Codable {
    let grantType: String
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case username
        case password
    }
    
    init(grantType: String, username: String, password: String) {
        self.grantType = grantType
        self.username = username
        self.password = password
    }
}
