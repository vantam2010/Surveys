//
//  LoginService.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol : class {
    func login(username: String, password: String, completion: @escaping ((Result<OauthToken, CustomError>) -> Void))
}

final class LoginService : LoginServiceProtocol {
    static let shared = LoginService()
    
    func login(username: String, password: String, completion: @escaping ((Result<OauthToken, CustomError>) -> Void)) {
        let params: [String: Any] = ["grant_type": "password", "username": username, "password": password]
        _ = Networking.shared.makeRequest(resource: Resource.init(path: "oauth/token", method: .post, params: params), completion: completion)
    }
}
