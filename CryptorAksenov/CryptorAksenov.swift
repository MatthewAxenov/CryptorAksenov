//
//  CryptorAksenov.swift
//  CryptorAksenov
//
//  Created by Матвей on 18.10.2023.
//

import Foundation
import CoreData

public final class CryptorAksenov {
    
    /// Возвращает список расшифрованных записей из базы данных
    
    public static var strings: [String] {
        get async throws {
            
            var error: Unmanaged<CFError>?
            
            let privateKey = CryptorKeysHelper.loadKey(name: CryptorKeysHelper.privateKeyName)
            
            guard let privateKey = privateKey else {
                throw error!.takeRetainedValue() as Error
            }
            
            let cryptedStrings = CoreDataManager.shared.fetch()
            var newArrayOfStrings = [String]()
            for string in cryptedStrings {
                let newString = try CryptorAksenov.decryptEncodedString(key: privateKey, string: string.stringValue!)
                newArrayOfStrings.append(newString)
            }
            return newArrayOfStrings
        }
    }
    
    /// Шифрует переданную строку и сохраняет её в базу данных
    
    public static func store(string: String) async throws {
        
        let publicKey = CryptorKeysHelper.loadKey(name: CryptorKeysHelper.publicKeyName)
        
        if let publicKey = publicKey {
            let encryptedString = try CryptorAksenov.encryptStringWithPrivateKey(string: string, key: publicKey)
            CoreDataManager.shared.saveCryptedString(cryptedString: encryptedString)
        } else {
            print("publicKey nil make keys will be called")
            let newPublicKey = try CryptorKeysHelper.makeKeys()
            let encryptedString = try CryptorAksenov.encryptStringWithPrivateKey(string: string, key: newPublicKey)
            CoreDataManager.shared.saveCryptedString(cryptedString: encryptedString)
        }
        
        
    }
}
