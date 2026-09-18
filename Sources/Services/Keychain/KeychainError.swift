//
//  KeychainError.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 25.08.2026.
//

import Foundation

enum KeychainError: Error {
    case itemNotFound
    case unexpectedData
    case unexpectedStatus(OSStatus)
}
