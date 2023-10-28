//
//  CryptorAksenov.swift
//  CryptorAksenov
//
//  Created by Матвей on 18.10.2023.
//

import Foundation

public final class CryptorAksenov {
    
    /// Возвращает список расшифрованных записей из базы данных
    
    public static var strings: [String] {
        get async throws {
                        
            let privateKey = CryptorKeysHelper.loadPrivateKey(name: CryptorKeysHelper.privateKeyName)
            
            guard let privateKey = privateKey else {
                throw CryptorAksenovErrors.privateKeyLoadFailed
            }
            
            let cryptedStrings = CoreDataManager.shared.fetch()
            var newArrayOfStrings = [String]()
            for string in cryptedStrings {
                guard let cryptedData = string.cryptedData else {
                    continue
                }
                let newString = try CryptorAksenov.decryptEncodedString(key: privateKey, string: cryptedData)
                newArrayOfStrings.append(newString)
            }
            return newArrayOfStrings
        }
    }
    
    /// Шифрует переданную строку и сохраняет её в базу данных
    
    public static func store(string: String, key: SecKey) async throws {
        let encryptedStringData = try encryptStringWithPublicKey(string: string, key: key)
        CoreDataManager.shared.saveCryptedString(cryptedString: encryptedStringData)
    }
}
