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
    fileprivate let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        service = LoginService.shared
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testLoginSucces() {
        
        let expectation = XCTestExpectation(description: "Login succesfull!")
        
        // Remove access token if it already has
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
                    XCTFail(error.localizedDescription)
                }
            }
        }

        wait(for: [expectation], timeout: timeout)
    }
    
    func testLoginFail() {
        
        let expectation = XCTestExpectation(description: "Login fail!")
        
        // Remove access token if it already has
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) != nil {
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_ACCESS_TOKEN)
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_TOKEN_TYPE)
            UserDefaults.standard.synchronize()
        }
        
        // login with username not exist in system
        service.login(username: "tamnguyen", password: "tamnguyen") { result in
            DispatchQueue.main.async {
                if result.value != nil {
                    XCTFail("Login successfully with fake username and password")
                } else if let error = result.error {
                    switch error {
                    case .unauthorized:
                        expectation.fulfill()
                    default:
                        XCTFail(error.localizedDescription)
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
