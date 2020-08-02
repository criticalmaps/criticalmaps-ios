//
//  RSA.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/5/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

public class RSA {
    enum RSAError: Error {
        case keyIsUnsupported
    }

    static let algorithm: SecKeyAlgorithm = .rsaSignatureMessagePKCS1v15SHA512

    public class func sign(_ data: Data, privateKey: SecKey) throws -> Data {
        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
            throw RSAError.keyIsUnsupported
        }

        var error: Unmanaged<CFError>?
        guard let signature = SecKeyCreateSignature(privateKey,
                                                    algorithm,
                                                    data as CFData,
                                                    &error) as Data?
        else {
            throw error!.takeRetainedValue() as Error
        }
        return signature
    }

    public class func verify(_ data: Data, publicKey: SecKey, signature: Data) throws -> Bool {
        guard SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm) else {
            throw RSAError.keyIsUnsupported
        }

        var error: Unmanaged<CFError>?

        let valid = SecKeyVerifySignature(publicKey, algorithm, data as CFData, signature as CFData, &error)
        if let error = error {
            throw error.takeRetainedValue() as Error
        }

        return valid
    }
}
