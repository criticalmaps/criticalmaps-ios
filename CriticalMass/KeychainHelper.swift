//
//  KeychainHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 7/8/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

class KeychainHelper {
    enum KeychainError: Error {
        case cantFindMatchingKey
        case storeKey
        case deletionFailed
    }

    class func save(data: Data, with keyReference: String) throws {
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: keyReference,
                                       kSecValueRef as String: data]
        let status = SecItemAdd(addquery as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.storeKey }
    }

    class func load(with keyReference: String) throws -> Data {
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: keyReference,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                       kSecReturnRef as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { throw KeychainError.cantFindMatchingKey }
        let key = item as! SecKey

        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(key, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        return data as Data
    }

    class func delete(with keyReference: String) throws {
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassKey,
                                          kSecAttrApplicationTag as String: keyReference,
                                          kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                          kSecReturnRef as String: true]

        let status = SecItemDelete(deleteQuery as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.deletionFailed
        }
    }
}
