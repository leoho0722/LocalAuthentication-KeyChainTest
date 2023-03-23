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
    
    /// 將帳號、密碼存入 KeyChain 內
    /// - Parameters:
    ///   - service: 服務，像是網址 (我看教學都寫網址啦)
    ///   - account: 要存入 KeyChain 的帳號
    ///   - password: 要存入 KeyChain 的密碼
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
    
    /// 從 KeyChain 內讀出對應帳號的密碼
    /// - Parameters:
    ///   - service: 服務，像是網址 (我看教學都寫網址啦)
    ///   - account: 要讀出密碼的帳號
    /// - Returns: 密碼，以 Data 型態回傳
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
    
    /// 更新 KeyChain 內的密碼
    /// - Parameters:
    ///   - service: 服務，像是網址 (我看教學都寫網址啦)
    ///   - account: 要更新的帳號
    ///   - password: 新的密碼
    static func updateInKeyChain(service: String, account: String, password: Data) throws {
        let query: [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword as AnyObject, // 通用密碼
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject, // 要更新的帳號
            kSecAttrSynchronizable as String : kCFBooleanTrue // 啟用跨裝置同步 KeyChain (同 Apple ID)
        ]
        
        let status = SecItemUpdate(query as CFDictionary,
                                   [kSecValueData as String : password as AnyObject] as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
    }
    
    /// 將帳號、密碼從 KeyChain 裡刪除
    /// - Parameters:
    ///   - service: 服務，像是網址 (我看教學都寫網址啦)
    ///   - account: 要刪除的帳號
    static func deleteFromKeyChain(service: String, account: String) throws {
        let query: [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword as AnyObject, // 通用密碼
            kSecAttrService as String : service as AnyObject,
            kSecAttrAccount as String : account as AnyObject, // 要刪除的帳號
            kSecReturnData as String : kCFBooleanTrue, // 查詢到的密碼
            kSecAttrSynchronizable as String : kCFBooleanTrue // 啟用跨裝置同步 KeyChain (同 Apple ID)
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown(status)
        }
    }   
}
