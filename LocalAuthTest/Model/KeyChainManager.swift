//
//  KeyChainManager.swift
//  LocalAuthTest
//
//  Created by Leo Ho on 2022/6/29.
//

import Foundation

class KeyChainManager {
    
    enum KeyChainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func saveToKeyChain(service: String, account: String, password: Data) throws {
       // Class、Service、Account、Password
        let query: [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword as AnyObject,
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject,
            kSecValueData as String : password as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeyChainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
    }
    
    static func getFromKeyChain(service: String, account: String) -> Data? {
        // Service、Account、Return-Data、MatchLimit
        let query: [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword as AnyObject,
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
}
