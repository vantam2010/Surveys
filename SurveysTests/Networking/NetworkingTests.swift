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
        url = URL.init(string: Configuration.baseUrl)
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
    func testFetchSurveysSuccessfulResponse_WithData() {
        session.data = readDataFromJSONFile(fileName: "SurveyList")
        session.respone = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        let expectation = XCTestExpectation(description: "Fetch data successful")
        let resource = Resource<[Survey]>.init(baseUrl: Configuration.baseUrl, path: "surveys.json", method: .get, params: [:])
        _ = networking.makeRequest(resource: resource) { result in
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
    func testFetchSurveysSuccessful_ResponseNil() {
        session.data = nil
        session.respone = HTTPURLResponse.init(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        let expectation = XCTestExpectation(description: "Fetch data fail with nil data")
        let resource = Resource<[Survey]>.init(baseUrl: Configuration.baseUrl, path: "surveys.json", method: .get, params: [:])
        _ = networking.makeRequest(resource: resource) { result in
            if let error = result.error {
                switch error {
                case .resultNilOrEmpty:
                    expectation.fulfill()
                default:
                    XCTFail(error.localizedDescription)
                }
            } else {
                XCTFail("Expected data nil, but got value.")
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
        let resource = Resource<OauthToken>.init(baseUrl: Configuration.baseUrl, path: "oauth/token", method: .get, params: [:])
        _ = networking.makeRequest(resource: resource) { result in
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
    func testLoginFail_ResponeUnauthorized() {
        session.data = nil
        session.respone = HTTPURLResponse.init(url: url, statusCode: 401, httpVersion: "HTTP/1.1", headerFields: nil)
        let expectation = XCTestExpectation(description: "Expected Unauthorized respone")
        let resource = Resource<OauthToken>.init(baseUrl: Configuration.baseUrl, path: "oauth/token", method: .get, params: [:])
        _ = networking.makeRequest(resource: resource) { result in
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
