//
//  KeychainHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 7/8/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public class KeychainHelper {
    enum KeychainError: Error {
        case cantFindMatchingKey
        case storeKeyFailed
        case deletionFailed
    }
    
    public class func save(keyData: Data, with keyReference: String) throws {
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: keyReference,
                                       kSecValueData as String: keyData]
        
        SecItemDelete(addquery as CFDictionary)
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.storeKeyFailed
        }
    }
    
    public class func load(with keyReference: String) throws -> Data {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: keyReference,
                                       kSecReturnData as String  : kCFBooleanTrue!,
                                       kSecMatchLimit as String  : kSecMatchLimitOne]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError.cantFindMatchingKey }
        
        return item as! Data
    }
    
    public class func delete(with keyReference: String) throws {
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: keyReference]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deletionFailed
        }
    }
}
