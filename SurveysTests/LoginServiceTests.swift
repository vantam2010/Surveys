//
//  LoginServiceTests.swift
//  SurveysTests
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class LoginServiceTests: XCTestCase {
    
    fileprivate var service : LoginService!
    
    override func setUp() {
        super.setUp()
        self.service = LoginService.shared
    }
    
    override func tearDown() {
        self.service = nil
        super.tearDown()
    }
    
    func testLogin() {
        
        let expectation = XCTestExpectation(description: "Login succesfull!")
        
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) != nil {
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_ACCESS_TOKEN)
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_TOKEN_TYPE)
            UserDefaults.standard.synchronize()
        }
        
        service.login(username: Configuration.USER_NAME, password: Configuration.PASSWORD) { result in
            DispatchQueue.main.async {
                if let value = result.value {
                    if let token = value.access_token, let type = value.token_type {
                        UserDefaults.standard.set(token, forKey: Configuration.OAUTH_ACCESS_TOKEN)
                        UserDefaults.standard.set(type, forKey: Configuration.OAUTH_TOKEN_TYPE)
                        UserDefaults.standard.synchronize()
                        expectation.fulfill()
                    }
                } else if let error = result.error {
                    XCTAssert(false, Utils.getErrorMessage(error: error))
                }
            }
        }

        wait(for: [expectation], timeout: 30.0)
    }
}
