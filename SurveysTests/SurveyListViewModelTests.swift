//
//  SurveyListViewModelTests.swift
//  SurveysTests
//
//  Created by Apple on 10/22/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class SurveyListViewModelTests: XCTestCase {
    
    fileprivate var loginService : LoginService!
    fileprivate var surveyService : SurveyService!
    fileprivate var viewModel : SurveyListViewModel!
    fileprivate var dataSource : GenericDataSource<Survey>!
    fileprivate let timeout: TimeInterval = 60
    
    override func setUp() {
        super.setUp()
        loginService = LoginService.shared
        surveyService = SurveyService.shared
        dataSource = GenericDataSource<Survey>()
        viewModel = SurveyListViewModel.init(dataSource: dataSource)
    }
    
    override func tearDown() {
        viewModel = nil
        dataSource = nil
        loginService = nil
        surveyService = nil
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
    
    // get data from page 1 to 10 and max item is 20
    func testFetchData_With_MaxItem_20() {
        dataSource?.paging.max_item = 20
        
        let expectation = XCTestExpectation(description: "Loading surveys")
        
        authenticateUser { [weak self] authenticated in
            guard let self = self else {return}
            if authenticated {
                self.viewModel.onErrorHandling = { error in
                    XCTFail(error.localizedDescription)
                }
                
                self.dataSource.data.addObserver(self) { _ in
                    if self.dataSource.isLoadMore {
                        self.viewModel.fetchData()
                    } else {
                        expectation.fulfill()
                    }
                }
                
                self.viewModel.fetchData()
            } else {
                XCTFail("Login fail")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(dataSource.data.value.count, 20, "We should have loaded exactly 20 items.")
        
        addTeardownBlock {
            
        }
    }
    
    // get data from page 1 to 10 and max item is 100
    func testFetchData_With_MaxItem_100() {
        dataSource?.paging.max_item = 100
        
        let expectation = XCTestExpectation(description: "Loading surveys")
        
        authenticateUser { [weak self] authenticated in
            guard let self = self else {return}
            if authenticated {
                self.viewModel.onErrorHandling = { error in
                    XCTFail(error.localizedDescription)
                }
                
                self.dataSource.data.addObserver(self) { _ in
                    if self.dataSource.isLoadMore {
                        self.viewModel.fetchData()
                    } else {
                        expectation.fulfill()
                    }
                }
                
                self.viewModel.fetchData()
            } else {
                XCTFail("Login fail")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(dataSource.data.value.count, 100, "We should have loaded exactly 100 items.")
    }
}
