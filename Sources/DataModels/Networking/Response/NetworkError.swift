//
//  NetworkErrors.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 02.09.2026.
//

import Foundation
import OpenAPIRuntime

enum NetworkError: LocalizedError {
    case noInternetAccess, serverNotRunning, couldNotDecode, expiredAccess, notFoundError, unexpectedStatus(Int), unknown(Error)
    var errorDescription: String? {
        switch self {
        case .serverNotRunning: 
            "Local server is not running."
        case .noInternetAccess:
            "No internet access."
        case .couldNotDecode:
            "Could not decode response."
        case .expiredAccess:
            "Token has expired."
        case .notFoundError:
            "User not found."
        case .unexpectedStatus(let status):
            "Unexpected status: \(status)"
        case .unknown(let error):
            "Unknown error."
        }
    }
    init(error: Error){
        let error = (error as? ClientError)?.underlyingError ?? error
        switch error {
        case let e as APIError:
            switch e {
            case .notFound: self = .notFoundError
            case .notAuthenticated: self = .expiredAccess
            case .unexpected(let status): self = .unexpectedStatus(status)
            case .invalidCredentials: self = .unknown(e)
            }
        case let e as URLError:
            switch e.code {
            case .notConnectedToInternet: self = .noInternetAccess
            case .cannotConnectToHost, .timedOut: self = .serverNotRunning
            default: self = .unknown(e)
            }
        case is DecodingError: self = .couldNotDecode
        default: self = .unknown(error)
        }
    }
}
