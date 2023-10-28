//
//  CryptorKeysHelper.swift
//  CryptorAksenov
//
//  Created by Матвей on 26.10.2023.
//

import Foundation

public final class CryptorKeysHelper {
    
    public static let privateKeyName = "privateKey"
    public static let publicKeyName = "publicKey"
    
    
    public static func makeKeys() throws -> SecKey {
        
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
                kSecAttrIsPermanent as String       : false,
                kSecAttrApplicationTag as String    : tag,
                kSecAttrAccessControl as String     : access
            ]
        ]
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        try saveKey(key: privateKey, name: privateKeyName)
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("Can't get public key")
            throw error!.takeRetainedValue() as Error
        }
        
        try saveKey(key: publicKey, name: publicKeyName)
        return publicKey
    }
    
    
    public static func saveKey(key: SecKey, name: String) {
        
        let tag = name.data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                       kSecValueRef as String: key]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print("not right status")
            return
        }
    }
    
    
    public static func loadKey(name: String) -> SecKey? {
        let tag = name.data(using: .utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassKey,
                                    kSecAttrApplicationTag as String: tag,
                                    kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                    kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            print("nil while load key")
            return nil
        }
        return (item as! SecKey)
    }
}
