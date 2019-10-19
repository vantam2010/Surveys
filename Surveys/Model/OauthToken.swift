//
//  OauthToken.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class OauthToken: Decodable {
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var created_at: Int64?
}
