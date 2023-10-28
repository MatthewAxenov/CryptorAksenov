//
//  CryptorAksenovErrors.swift
//  CryptorAksenov
//
//  Created by Матвей on 28.10.2023.
//

import Foundation

enum CryptorAksenovErrors: Error {
    case publicKeyCreationFailed
    case algorithmNotSupported
    case encryptionFailed
    case decryptionFailed
    case privateKeyLoadFailed
}
