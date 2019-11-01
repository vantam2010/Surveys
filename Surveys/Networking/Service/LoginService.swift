//
//  LoginService.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol : class {
    func login(completion: @escaping ((Result<OauthToken, ErrorResult>) -> Void))
}

final class LoginService : LoginServiceProtocol {
    static let shared = LoginService()
    
    let oauthUser = OauthUser.init(grantType: "password", username: Configuration.USER_NAME, password: Configuration.PASSWORD)
    
    func login(completion: @escaping ((Result<OauthToken, ErrorResult>) -> Void)) {
        _ = Networking.shared.makeRequest(resource: Resource.init(path: "oauth/token", method: .post, params: oauthUser.dictionary ?? [:]), completion: completion)
    }
}
