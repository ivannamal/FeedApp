//
//  AuthService.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials, empty, networkError(NetworkError)
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Invalid username or password."
        case .empty:
            "Empty username or password."
        case .networkError(let error):
            error.errorDescription
        }
    }
}

final class AuthService: AuthServiceProtocol {
    
    private let api: API
    
    init(api: API = AppAPI.client) {
        self.api = api
    }
    
    func signIn(username: String, password: String) async throws {
        guard !username.isEmpty, !password.isEmpty else {
            throw AuthError.empty
        }
        do {
            _ = try await api.login(username: username, password: password)
        } catch APIError.invalidCredentials {
            throw AuthError.invalidCredentials
        } catch {
            throw AuthError.networkError(NetworkError(error: error))
        }
    }
    
    func signOut () {
        api.signOut()
    }
}
