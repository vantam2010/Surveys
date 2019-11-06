//
//  KeychainService.swift
//  Surveys
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

struct KeychainService {
    static let shared = KeychainService()
    
    func save(token: String) throws {
        guard let encodedToken = token.data(using: .utf8) else {
            throw KeychainError.string2DataConversionError
        }
        // Instantiate a new default keychain query
        let forKeys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue]
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, Configuration.getDomain(), Configuration.username, encodedToken], forKeys: forKeys)
        // Add the new keychain item
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status != errSecSuccess {
            throw error(from: status)
        }
    }
    func update(token: String) throws {
        guard let encodedToken = token.data(using: .utf8) else {
            throw KeychainError.string2DataConversionError
        }
        // Instantiate a new default keychain query
        let forKeys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue]
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, Configuration.getDomain(), Configuration.username], forKeys: forKeys)
        let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue: encodedToken] as CFDictionary)
        if status != errSecSuccess {
            throw error(from: status)
        }
    }
    func getToken() throws -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let objects = [kSecClassGenericPasswordValue, Configuration.getDomain(), Configuration.username, kCFBooleanTrue, kSecMatchLimitOneValue] as [Any]
        let forKeys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue]
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: objects, forKeys: forKeys)
        var dataTypeRef: AnyObject?
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        switch status {
        case errSecSuccess:
            guard let retrievedData = dataTypeRef as? Data,
                let contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
                else {
                    throw KeychainError.data2StringConversionError
            }
            return contentsOfKeychain
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }
    func removeTokend() throws {
        // Instantiate a new default keychain query
        let forKeys = [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue]
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, Configuration.getDomain(), Configuration.username, kCFBooleanTrue], forKeys: forKeys)
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    func error(from status: OSStatus) -> KeychainError {
        var message = NSLocalizedString("Unhandled Error", comment: "")
        if #available(iOS 11.3, *) {
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                message = errorMessage
            }
        }
        return KeychainError.unhandledError(message: message)
    }
}
