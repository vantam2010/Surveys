//
//  SurveyTests.swift
//  SurveysTests
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class SurveyTests: XCTestCase {
    private var survey: Survey!
    override func setUp() {
        super.setUp()
        survey = Survey.dummy
    }
    override func tearDown() {
        survey = nil
        super.tearDown()
    }
    // Expected all properties has value
    func testSurveyModel() {
        XCTAssertEqual(survey.id, "id", "Expected has id.")
        XCTAssertEqual(survey.title, "title", "Expected has title.")
        XCTAssertEqual(survey.description, "description", "Expected has description.")
        XCTAssertEqual(survey.coverImageUrl, "coverImageUrl", "Expected has coverImageUrl.")
    }
}
