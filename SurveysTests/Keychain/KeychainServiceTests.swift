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
        } catch (let e) {
            XCTFail("Saving token failed with \(e.localizedDescription).")
        }
    }
    
    func testDuplicateSaveToken() {
        do {
            try service.save(token: "token")
            try service.save(token: "newToken")
        } catch (let e) {
            if let keychainError = e as? KeychainError {
                XCTAssertEqual("The specified item already exists in the keychain.", keychainError.localizedDescription)
            }
        }
    }
    
    func testGetToken() {
        do {
            try service.save(token: "token")
            let token = try service.getToken()
            XCTAssertEqual("token", token)
        } catch (let e) {
            XCTFail("Get token failed with \(e.localizedDescription).")
        }
    }
    
    func testUpdateToken() {
        do {
            try service.save(token: "token")
            try service.update(token: "newToken")
            let token = try service.getToken()
            XCTAssertEqual("newToken", token)
        } catch (let e) {
            XCTFail("Updating token failed with \(e.localizedDescription).")
        }
    }
    
    func testRemoveToken() {
        do {
            try service.save(token: "token")
            try service.removeTokend()
            XCTAssertNil(try service.getToken())
        } catch (let e) {
            XCTFail("Saving token failed with \(e.localizedDescription).")
        }
    }
}
