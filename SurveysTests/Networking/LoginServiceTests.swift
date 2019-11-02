////
////  LoginServiceTests.swift
////  SurveysTests
////
////  Created by Apple on 10/19/19.
////  Copyright © 2019 TamNguyen. All rights reserved.
////
//

import XCTest
@testable import Surveys

class LoginServiceTests: XCTestCase {
    
    fileprivate var service : LoginServiceMock!
    fileprivate let timeout: TimeInterval = 3
    
    override func setUp() {
        super.setUp()
        service = LoginServiceMock()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    func testLoginSuccess() {
        service.shouldSuccess = true
        
        let expectation = XCTestExpectation(description: "Login successfully")

        service.login { result in
            if result.value != nil {
                expectation.fulfill()
            } else if let error = result.error {
                XCTFail(error.localizedDescription)
            } else {
                XCTFail("Handle missing result")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
        
        addTeardownBlock {
            self.service.shouldSuccess = false
        }
    }
    
    func testLoginfail() {
        service.shouldSuccess = false
        
        let expectation = XCTestExpectation(description: "Login fail")
        
        service.login { result in
            if result.value != nil {
                XCTFail("Expected nil, but it has value")
            } else if let error = result.error {
                switch error {
                case .unauthorized:
                    expectation.fulfill()
                default:
                    XCTFail(error.localizedDescription)
                }
            } else {
                XCTFail("Handle missing result")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
