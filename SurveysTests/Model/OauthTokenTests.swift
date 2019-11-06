//
//  OauthTokenTests.swift
//  SurveysTests
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class OauthTokenTests: XCTestCase {
    private var oauthToken: OauthToken!
    override func setUp() {
        super.setUp()
        oauthToken = OauthToken.dummy
    }
    override func tearDown() {
        oauthToken = nil
        super.tearDown()
    }
    // Expected all properties has value
    func testOauthTokenModel() {
        XCTAssertEqual(oauthToken.accessToken, "accessToken", "Expected has accessToken.")
        XCTAssertEqual(oauthToken.tokenType, "tokenType", "Expected has tokenType.")
        XCTAssertEqual(oauthToken.expiresIn, 7200, "Expected has expiresIn.")
        XCTAssertEqual(oauthToken.createdAt, 1572606599, "Expected has createdAt.")
    }
}
