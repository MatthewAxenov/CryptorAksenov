//
//  CryptorAksenovCryptExtension.swift
//  CryptorAksenov
//
//  Created by Матвей on 26.10.2023.
//

import Foundation

extension CryptorAksenov {
    
    public static func encryptStringWithPrivateKey(string: String, key: SecKey) throws -> String {
        
        var error: Unmanaged<CFError>?
        
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        guard SecKeyIsAlgorithmSupported(key, .encrypt, algorithm) else {
            print("cant encrypt - algorythm not supported")
            throw error!.takeRetainedValue() as Error
        }
        
        let stringData = string.data(using: .utf8)!
        let encryptedStringData = SecKeyCreateEncryptedData(key, algorithm,
                                                            stringData as CFData,
                                                            &error) as Data?
        guard let encryptedStringData = encryptedStringData else {
            print("encryptedStringData nil")
            throw error!.takeRetainedValue() as Error
        }
        
        let encryptedString = String(decoding: encryptedStringData, as: UTF8.self)
        print("enencryptedString - \(encryptedString)")
        
        return encryptedString
    }
    
    public static func decryptEncodedString(key: SecKey, string: String) throws -> String {
        
        var error: Unmanaged<CFError>?
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        
        let stringData = string.data(using: .utf8)
        
        guard let stringData = stringData else {
            throw error!.takeRetainedValue() as Error
        }
        
        guard SecKeyIsAlgorithmSupported(key, .decrypt, algorithm) else {
            print("can't decrypt")
            throw error!.takeRetainedValue() as Error
            
        }
        
        let clearTextData = SecKeyCreateDecryptedData(key,
                                                      algorithm,
                                                      stringData as CFData,
                                                      &error) as Data?
        guard let clearTextData = clearTextData else {
            print("clearTextData nil")
            throw error!.takeRetainedValue() as Error
            
        }
        let clearText = String(decoding: clearTextData, as: UTF8.self)
        
        print("decrypted String - \(clearText)")
        return clearText
        
    }
}
