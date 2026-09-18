//
//  AuthServiceProtocol.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

import Foundation

protocol AuthServiceProtocol {
    
    func signIn(username: String, password: String) async throws
    func signOut()
}
