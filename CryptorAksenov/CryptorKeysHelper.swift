//
//  CryptorKeysHelper.swift
//  CryptorAksenov
//
//  Created by Матвей on 26.10.2023.
//

import Foundation
import Security

public final class CryptorKeysHelper {
    
    public static let privateKeyName = "privateKeyNameTag1112"
    
    
    public static func returnPublicKey() throws -> SecKey {
        let privateKey = try loadOrMakePrivateKey()
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw CryptorAksenovErrors.publicKeyCreationFailed
        }
        return publicKey
    }
    
    
    public static func loadOrMakePrivateKey() throws -> SecKey {
        if let privateKey = loadPrivateKey(name: privateKeyName) {
            return privateKey
        } else {
            let privateKey = try makePrivateKey()
            return privateKey
        }
    }
    
    
    private static func makePrivateKey() throws -> SecKey {
                
        let access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     .privateKeyUsage,
                                                     nil)!
        
        let tag = privateKeyName.data(using: .utf8)!
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String           : kSecAttrKeyTypeEC,
            kSecAttrKeySizeInBits as String     : 256,
            kSecAttrTokenID as String           : kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String : [
                kSecAttrIsPermanent as String       : true,
                kSecAttrApplicationTag as String    : tag,
                kSecAttrAccessControl as String     : access
            ]
        ]
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return privateKey
    }
    
    public static func loadPrivateKey(name: String) -> SecKey? {
        let tag = name.data(using: .utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: tag,
                                    kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                    kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }
        return (item as! SecKey)
    }
}
