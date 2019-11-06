//
//  OauthToken.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct OauthToken: Codable {
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let createdAt: Int64?
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case createdAt = "created_at"
    }
    init(accessToken: String, tokenType: String, expiresIn: Int, createdAt: Int64) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.createdAt = createdAt
    }
}
