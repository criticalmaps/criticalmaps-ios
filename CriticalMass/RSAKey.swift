//
//  RSAKey.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/5/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public class RSAKey {
    static let keychainTag = "de.pokuslabs.criticalmassberlin.keys.privateKey"

    enum RSAKeyError: Error {
        case copyingPublicKeyFailed
        case loadingFailed
        case missingTag
        case deletionFailed
    }

    private(set)
    var secKey: SecKey

    private var tag: String?

    /// Creates a public key from Data
    ///
    /// - Parameter data:
    /// - Throws: an error if the data doesn't represent a valid public key
    public init(data: Data) throws {
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                      kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                      kSecAttrKeySizeInBits as String: 2048]
        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(data as CFData,
                                             options as CFDictionary,
                                             &error)
        else {
            throw error!.takeRetainedValue() as Error
        }
        secKey = key
    }

    /// Loads a key from keychain
    ///
    /// - Parameter tag: The tag that has been used to store the key in the keychain
    /// - Throws: an error if loading failed
    public init(fromKeychain tag: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: tag,
                                    kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                    kSecReturnRef as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw RSAKeyError.loadingFailed
        }
        self.tag = tag
        secKey = item as! SecKey
    }

    public convenience init(tag: String) throws {
        // TODO: add tests + documentation
        if let _ = try? RSAKey(fromKeychain: tag) {
            try self.init(fromKeychain: tag)
        } else {
            try self.init(randomKey: tag)
        }
    }

    /// Creates a random key and stores it in keychain
    ///
    /// - Parameter tag: The tag will be used to store the key in the keychain and can be used later to retrieve the key from keychain
    /// - Throws: an error if the creation failed
    public init(randomKey tag: String, isPermament: Bool = true) throws {
        let tagData = tag.data(using: .utf8)!
        let attributes: [String: Any] =
            [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
             kSecAttrKeySizeInBits as String: 2048,
             kSecPrivateKeyAttrs as String:
                 [kSecAttrIsPermanent as String: isPermament,
                  kSecAttrApplicationTag as String: tagData]]

        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        self.tag = tag
        secKey = key
    }

    public func publicKeyDataRepresentation() throws -> Data {
        guard let publicKey = SecKeyCopyPublicKey(secKey) else {
            throw RSAKeyError.copyingPublicKeyFailed
        }
        var error: Unmanaged<CFError>?
        guard let data = SecKeyCopyExternalRepresentation(publicKey, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        return data as Data
    }

    public func delete() throws {
        guard let tag = self.tag else {
            throw RSAKeyError.missingTag
        }
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: tag,
                                    kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                                    kSecReturnRef as String: true]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw RSAKeyError.deletionFailed
        }
    }

    public var privateKey: SecKey? {
        if tag != nil {
            return secKey
        }
        return nil
    }

    public var publicKey: SecKey? {
        if tag != nil {
            return SecKeyCopyPublicKey(secKey)
        }
        return secKey
    }
}
