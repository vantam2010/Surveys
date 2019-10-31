//
//  SurverServiceTests.swift
//  SurveysTests
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class SurverServiceTests: XCTestCase {
    
    fileprivate var loginService : LoginService!
    fileprivate var surveyService: SurveyService!
    fileprivate var paging: Paging!
    fileprivate let timeout: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        loginService = LoginService.shared
        surveyService = SurveyService.shared
        paging = Paging(page: 1, per_page: 10, max_item: 20)
    }
    
    override func tearDown() {
        loginService = nil
        surveyService = nil
        paging = nil
        super.tearDown()
    }
    
    func authenticateUser(completion: @escaping (Bool) -> ()) {
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) == nil {
            loginService.login(username: Configuration.USER_NAME, password: Configuration.PASSWORD) { result in
                if let value = result.value {
                    if let token = value.access_token, let type = value.token_type {
                        UserDefaults.standard.set(token, forKey: Configuration.OAUTH_ACCESS_TOKEN)
                        UserDefaults.standard.set(type, forKey: Configuration.OAUTH_TOKEN_TYPE)
                        UserDefaults.standard.synchronize()
                        
                        completion(true)
                    }
                } else if let error = result.error {
                    XCTFail(error.localizedDescription)
                }
                
                completion(false)
            }
        } else {
            completion(true)
        }
    }
    
    func testFetchData() {
        let expectation = XCTestExpectation(description: "Get data success")
        
        authenticateUser { [weak self] authenticated in
            guard let self = self else {return}
            if authenticated {
                self.surveyService.fetchData(paging: self.paging) { result in
                    if result.value != nil {
                        expectation.fulfill()
                    } else if let error = result.error {
                        XCTFail(error.localizedDescription)
                    } else {
                        XCTFail("Handle missing result")
                    }
                }
            } else {
                XCTFail("Login fail")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testCancelRequestFetchData() {
        let expectation = XCTestExpectation(description: "Expected task nil")
        
        authenticateUser { [weak self] authenticated in
            guard let self = self else {return}
            if authenticated {
                // giving a "previous" session
                self.surveyService.fetchData(paging: self.paging) { (_) in
                    // ignore call
                }
                
                // Expected to task nil after cancel
                self.surveyService.cancelFetchData()
                if self.surveyService.task == nil {
                    expectation.fulfill()
                } else {
                    XCTFail("Cancel task fail")
                }
            } else {
                XCTFail("Login fail")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    // expect return unauthorized error
    func testFetchData_Without_AccessToken() {
        let expectation = XCTestExpectation(description: "Expected unauthorized")
        
        // Remove access token for this test case
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) != nil {
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_ACCESS_TOKEN)
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_TOKEN_TYPE)
            UserDefaults.standard.synchronize()
        }
        
        surveyService.fetchData(paging: paging) { result in
            DispatchQueue.main.async {
                
                if let errorResult = result.error {
                    if errorResult.localizedDescription == ErrorResult<Any>.unauthorized.localizedDescription {
                        expectation.fulfill()
                    } else {
                        XCTFail(errorResult.localizedDescription)
                    }
                } else {
                    XCTFail("No error thrown")
                }
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
