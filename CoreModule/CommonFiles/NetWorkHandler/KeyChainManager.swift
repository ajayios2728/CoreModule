//
//  KeyChainManager.swift
//  NextPeak
//
//  Created by SivaCerulean Technologies on 02/08/23.
//  Copyright © 2023 Balakrishnan Ponraj. All rights reserved.
//

import Security
import Foundation
import UIKit


//🔹 Usage Examples
//// Save token
//KeyChainManager.save(value: "myBearerToken123", for: "AccessToken")
//
//// Get token
//let token = KeyChainManager.getValue(for: "AccessToken")
//print("🔑 Token:", token ?? "No token found")
//
//// Update token
//KeyChainManager.update(value: "newBearerToken456", for: "AccessToken")
//
//// Delete token
//KeyChainManager.delete(for: "AccessToken")

struct KeyChainManager {
    
    static func saveValueToKeychain() {
        
        guard let value = UIDevice.current.identifierForVendor?.uuidString else {return}
        
        let key = "NP-UUID"
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to store value in Keychain. Status: \(status)")
        }
    }
        static func getValueFromKeychain() -> String? {
            let key = "NP-UUID"
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess, let data = item as? Data {
                return String(data: data, encoding: .utf8)
            }
            
            return nil
        }
        
    static func deleteValueFromKeychain() {
        let key = "NP-UUID"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete value from Keychain. Status: \(status)")
        }
    }
    }


extension KeyChainManager {
    
    @discardableResult
    static func save(value: String, for key: String) -> Bool {
        let data = value.data(using: .utf8)!
        
        // If it already exists, update instead of adding a duplicate
        if getValue(for: key) != nil {
            return update(value: value, for: key)
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("❌ Failed to save to Keychain. Status: \(status)")
            return false
        }
        return true
    }
    
    static func getValue(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    @discardableResult
    static func update(value: String, for key: String) -> Bool {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status != errSecSuccess {
            print("❌ Failed to update Keychain. Status: \(status)")
            return false
        }
        return true
    }
    
    @discardableResult
    static func delete(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("❌ Failed to delete from Keychain. Status: \(status)")
            return false
        }
        return true
    }
}



