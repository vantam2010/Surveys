//
//  NetworkingTests.swift
//  SurveysTests
//
//  Created by Apple on 11/2/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class NetworkingTests: XCTestCase {
    fileprivate var url: URL!
    fileprivate var session: URLSessionMock!
    fileprivate var networking: Networking!
    fileprivate var surveyData: Data?
    fileprivate let timeout: TimeInterval = 6
    
    override func setUp() {
        super.setUp()
        url = URL.init(string: Configuration.BASE_URL)
        session = URLSessionMock()
        networking = Networking.init(session: session)
    }
    
    override func tearDown() {
        session = nil
        networking = nil
        surveyData = nil
        super.tearDown()
    }

    func readDataFromJSONFile(fileName: String) -> Data? {
        var data: Data?
        if let path = Bundle.init(for: NetworkingTests.self).path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            } catch {
                // Handle error here
            }
        }
        return data
    }
}

// MARK: - Survey Tests
extension NetworkingTests {
    func testFetchSurveysSuccessfulResponse() {
        session.data = readDataFromJSONFile(fileName: "SurveyList")
        session.respone = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let expectation = XCTestExpectation(description: "Fetch data successful")
        
        _ = networking.makeRequest(resource: Resource<[Survey]>.init(baseUrl: Configuration.BASE_URL, path: "surveys.json", method: .get, params: [:])) { result in
            
            if let error = result.error {
                XCTFail(error.localizedDescription)
            } else {
                if result.value == nil {
                    XCTFail(ErrorResult.resultNilOrEmpty.localizedDescription)
                } else {
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}

// MARK: - Login Tests
extension NetworkingTests {
    func testLoginSuccessfulResponse() {
        session.data = readDataFromJSONFile(fileName: "OauthToken")
        session.respone = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let expectation = XCTestExpectation(description: "Login successful")
        
        _ = networking.makeRequest(resource: Resource<OauthToken>.init(baseUrl: Configuration.BASE_URL, path: "oauth/token", method: .get, params: [:])) { result in
            
            if let error = result.error {
                XCTFail(error.localizedDescription)
            } else {
                if result.value == nil {
                    XCTFail(ErrorResult.resultNilOrEmpty.localizedDescription)
                } else {
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testLoginFail_UnauthorizedRespone() {
        session.data = nil
        session.respone = HTTPURLResponse.init(url: url, statusCode: 401, httpVersion: "HTTP/1.1", headerFields: nil)
        
        let expectation = XCTestExpectation(description: "Expected Unauthorized respone")
        
        _ = networking.makeRequest(resource: Resource<OauthToken>.init(baseUrl: Configuration.BASE_URL, path: "oauth/token", method: .get, params: [:])) { result in

            if let error = result.error {
                switch error {
                case .unauthorized:
                    expectation.fulfill()
                default:
                    XCTFail(error.localizedDescription)
                }
            } else {
                XCTFail("Expected get error Unauthorized, but get value.")
            }
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}