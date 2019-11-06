//
//  KeychainServiceTests.swift
//  SurveysTests
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import XCTest
@testable import Surveys

class KeychainServiceTests: XCTestCase {
    var service: KeychainService!
    override func setUp() {
        super.setUp()
        service = KeychainService.init()
    }
    override func tearDown() {
        try? service.removeTokend()
        super.tearDown()
    }
    func testSaveToken() {
        do {
            try service.save(token: "token")
        } catch (let error) {
            if let errorResult = error as? ErrorResult {
                XCTFail("Saving token failed with \(errorResult.localizedDescription).")
            }
        }
    }
    func testDuplicateSaveToken() {
        do {
            try service.save(token: "token")
            try service.save(token: "newToken")
        } catch (let error) {
            if let keychainError = error as? KeychainError {
                XCTAssertEqual("The specified item already exists in the keychain.", keychainError.localizedDescription)
            }
        }
    }
    func testGetToken() {
        do {
            try service.save(token: "token")
            let token = try service.getToken()
            XCTAssertEqual("token", token)
        } catch (let error) {
            XCTFail("Get token failed with \(error.localizedDescription).")
        }
    }
    func testUpdateToken() {
        do {
            try service.save(token: "token")
            try service.update(token: "newToken")
            let token = try service.getToken()
            XCTAssertEqual("newToken", token)
        } catch (let error) {
            XCTFail("Updating token failed with \(error.localizedDescription).")
        }
    }
    func testRemoveToken() {
        do {
            try service.save(token: "token")
            try service.removeTokend()
            XCTAssertNil(try service.getToken())
        } catch (let error) {
            XCTFail("Saving token failed with \(error.localizedDescription).")
        }
    }
}
