//
//  CryptorAksenovCryptExtension.swift
//  CryptorAksenov
//
//  Created by Матвей on 26.10.2023.
//

import Foundation

extension CryptorAksenov {
    
    public static let encryptionAlgorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
    
    
    public static func encryptStringWithPublicKey(string: String, key: SecKey) throws -> Data {
        
        var error: Unmanaged<CFError>?
        guard SecKeyIsAlgorithmSupported(key, .encrypt, encryptionAlgorithm) else {
            throw CryptorAksenovErrors.algorithmNotSupported
        }
        
        let stringData = string.data(using: .utf8)!
        let encryptedStringData = SecKeyCreateEncryptedData(key, encryptionAlgorithm,
                                                            stringData as CFData,
                                                            &error) as Data?
        guard let encryptedStringData = encryptedStringData else {
            throw error?.takeRetainedValue() as Error? ?? CryptorAksenovErrors.encryptionFailed
        }
        return encryptedStringData
    }
    
    
    public static func decryptEncodedString(key: SecKey, string: Data) throws -> String {
        
        var error: Unmanaged<CFError>?
        guard SecKeyIsAlgorithmSupported(key, .decrypt, encryptionAlgorithm) else {
            throw CryptorAksenovErrors.algorithmNotSupported
        }
        
        let decryptedTextData = SecKeyCreateDecryptedData(key,
                                                      encryptionAlgorithm,
                                                      string as CFData,
                                                      &error) as Data?
        guard let decryptedTextData = decryptedTextData else {
            throw error?.takeRetainedValue() as Error? ?? CryptorAksenovErrors.decryptionFailed
        }
        let decryptedText = String(decoding: decryptedTextData, as: UTF8.self)
        return decryptedText
    }
}
