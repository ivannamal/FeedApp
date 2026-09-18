//
//  KeychainServiceProtocol.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 25.08.2026.
//
import Foundation

protocol KeychainServiceProtocol: Sendable {
    func write(data: Data, key: KeychainKey) throws
    func read(key: KeychainKey) throws -> Data
    func delete(key: KeychainKey) throws
}

extension KeychainServiceProtocol {
    func writeString(string: String, key: KeychainKey) throws {
        let data = Data(string.utf8)
        try write(data: data, key: key)
    }
    
    func readString(key: KeychainKey) throws -> String {
        let data = try read(key: key)
        guard let string = String(data: data, encoding: .utf8) else { throw KeychainError.unexpectedData }
        return string
    }
    
    func writeDate(date: Date, key: KeychainKey) throws {
        let string = String(date.timeIntervalSince1970)
        try writeString(string: string, key: key)
    }
}
