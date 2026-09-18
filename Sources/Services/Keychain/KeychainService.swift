//
//  KeychainService.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 25.08.2026.
//

import Foundation
import Security

final class KeychainService: KeychainServiceProtocol {
    private let serviceIdentifier = "feedApp.imalashchuk.com"
    
    private func query(for key: KeychainKey) -> [String: Any] {
      [kSecClass as String: kSecClassGenericPassword, //genp
       kSecAttrService as String: serviceIdentifier,
       kSecAttrAccount as String: key.rawValue]
    }
    
    func write(data: Data, key: KeychainKey) throws {
        var itemQuery = query(for: key)
        try delete(key: key)
        itemQuery[kSecValueData as String] = data
        let status = SecItemAdd(itemQuery as CFDictionary, nil)
        try checkStatus(status)
    }
    
    func read(key: KeychainKey) throws -> Data {
        var itemQuery = query(for: key)
        itemQuery[kSecReturnData as String] = true
        var result: AnyObject?
        let status = SecItemCopyMatching(itemQuery as CFDictionary, &result)
        try checkStatus(status)
        guard let result = result as? Data else { throw KeychainError.unexpectedData }
        return result
    }
    
    func delete(key: KeychainKey) throws {
        let itemQuery = query(for: key) as CFDictionary
        let status = SecItemDelete(itemQuery)
        if status != errSecItemNotFound {
            try checkStatus(status)
        }
    }
    
    private func checkStatus(_ status: OSStatus) throws {
        switch status {
        case errSecSuccess: return
        case errSecItemNotFound: throw KeychainError.itemNotFound
        default: throw KeychainError.unexpectedStatus(status)
        }
    }
}
