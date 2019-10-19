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
    
    fileprivate var service : SurveyService!
    
    override func setUp() {
        super.setUp()
        self.service = SurveyService.shared
    }
    
    override func tearDown() {
        self.service = nil
        super.tearDown()
    }
    
    // call testLogin to get access token before fetch data
    func testFetchData() {
        
        let expectation = XCTestExpectation(description: "Data fetch")
        
        service.fetchData(paging: Paging(page: 1, per_page: 10)) { result in
            DispatchQueue.main.async {
                if result.value != nil {
                    expectation.fulfill()
                } else if let error = result.error {
                    XCTAssert(false, Utils.getErrorMessage(error: error))
                }
            }
        }
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    // remove access token before call fetch data
    func testFetchData_Without_AccessToken() {
        
        let expectation = XCTestExpectation(description: "Unauthorized")
        
        if UserDefaults.standard.object(forKey: Configuration.OAUTH_ACCESS_TOKEN) != nil {
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_ACCESS_TOKEN)
            UserDefaults.standard.removeObject(forKey: Configuration.OAUTH_TOKEN_TYPE)
            UserDefaults.standard.synchronize()
        }
        
        service.fetchData(paging: Paging(page: 1, per_page: 10)) { result in
            DispatchQueue.main.async {
                
                if let errorResult = result.error {
                    switch errorResult {
                    case .unauthorized:
                        expectation.fulfill()
                    default:
                        XCTAssert(false, Utils.getErrorMessage(error: errorResult))
                    }
                } else if result.value != nil {
                    XCTAssert(false, "Server error")
                }
            }
        }
        
        wait(for: [expectation], timeout: 30.0)
    }
}
