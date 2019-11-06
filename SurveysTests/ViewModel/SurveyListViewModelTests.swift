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
    fileprivate var service: SurveyServiceMock!
    fileprivate var viewModel: SurveyListViewModel!
    fileprivate var dataSource: GenericDataSource<Survey>!
    fileprivate let timeout: TimeInterval = 3
    override func setUp() {
        super.setUp()
        service = SurveyServiceMock()
        dataSource = GenericDataSource<Survey>()
        viewModel = SurveyListViewModel.init(service: service, dataSource: dataSource)
    }
    override func tearDown() {
        viewModel = nil
        dataSource = nil
        service = nil
        super.tearDown()
    }
    // get data from page 1 to 10 and total results is 20
    func testFetchData_With_TotalResults_20() {
        service.shouldSuccess = true
        dataSource?.paging.totalResults = 20
        let expectation = XCTestExpectation(description: "Loading surveys")
        viewModel.onErrorHandling = { error in
            XCTFail(error.localizedDescription)
        }
        dataSource.data.addObserver(self) { _ in
            if self.dataSource.isLoadMore {
                self.viewModel.fetchData()
            } else {
                expectation.fulfill()
            }
        }
        viewModel.fetchData()
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(dataSource.data.value.count, 20, "We should have loaded exactly 20 items.")
        addTeardownBlock {
            self.service.emptyData = false
            self.service.shouldSuccess = false
        }
    }
    // get data from page 1 and get empty data
    func testFetchData_With_Empty_Result() {
        service.emptyData = true
        service.shouldSuccess = false
        let expectation = XCTestExpectation(description: "Loading surveys")
        viewModel.onErrorHandling = { error in
            switch error {
            case .resultNilOrEmpty:
                expectation.fulfill()
            default:
                XCTFail(error.localizedDescription)
            }
        }
        dataSource.data.addObserver(self) { result in
            if result.count == 0 {
                expectation.fulfill()
            } else {
                XCTFail("Expected empty data, but result return data from mock")
            }
        }
        viewModel.fetchData()
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(dataSource.data.value.count, 0, "Expected empty data.")
        addTeardownBlock {
            self.service.emptyData = false
            self.service.shouldSuccess = false
        }
    }
}
