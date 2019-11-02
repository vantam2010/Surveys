////
////  MockLoginService.swift
////  SurveysTests
////
////  Created by Apple on 11/1/19.
////  Copyright © 2019 TamNguyen. All rights reserved.
////
//

import Foundation
@testable import Surveys

final class LoginServiceMock {
    var shouldSuccess: Bool = true
}

// MARK: - LoginServiceProtocol
extension LoginServiceMock: LoginServiceProtocol {
    func login(completion: @escaping ((Result<OauthToken, ErrorResult>) -> Void)) {
        if shouldSuccess {
            completion(Result(value: OauthToken.dummy, or: .resultNilOrEmpty))
        } else {
            completion(.failure(.unauthorized))
        }
    }
}

// MARK: - Dummy
extension OauthToken {
    static let dummy: OauthToken = {
        return OauthToken.init(accessToken: "accessToken", tokenType: "tokenType", expiresIn: 7200, createdAt: 1572606599)
    }()
}
