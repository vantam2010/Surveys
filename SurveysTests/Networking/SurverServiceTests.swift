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
    fileprivate var service: SurveyServiceMock!
    fileprivate var paging: Paging!
    fileprivate let timeout: TimeInterval = 3
    override func setUp() {
        super.setUp()
        service = SurveyServiceMock()
        paging = Paging(page: 1, totalPages: 10, totalResults: 20)
    }
    override func tearDown() {
        service = nil
        paging = nil
        super.tearDown()
    }
    func testFetchData() {
        let expectation = XCTestExpectation(description: "Get data success")
        service.fetchData(paging: paging) { result in
            if result.value != nil {
                expectation.fulfill()
            } else if let error = result.error {
                XCTFail(error.localizedDescription)
            } else {
                XCTFail("Handle missing result")
            }
        }
        wait(for: [expectation], timeout: timeout)
    }
}
