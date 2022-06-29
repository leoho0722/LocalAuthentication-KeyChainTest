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
            kSecClass as String : kSecClassGenericPassword as AnyObject, // 通用密碼
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject, // 要存入 KeyChain 的帳號
            kSecValueData as String : password as AnyObject, // 要存入 KeyChain 的密碼
            kSecAttrSynchronizable as String : kCFBooleanTrue // 啟用跨裝置同步 KeyChain (同 Apple ID)
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
            kSecClass as String : kSecClassGenericPassword as AnyObject, // 通用密碼
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject, // 要查詢的帳號
            kSecReturnData as String : kCFBooleanTrue, // 查詢到的密碼
            kSecMatchLimit as String : kSecMatchLimitOne, // 只匹配一個
            kSecAttrSynchronizable as String : kCFBooleanTrue // 啟用跨裝置同步 KeyChain (同 Apple ID)
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        /*
         status = 0 -> 成功
         status = -25300 -> 失敗，找不到資料
         */
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
}
