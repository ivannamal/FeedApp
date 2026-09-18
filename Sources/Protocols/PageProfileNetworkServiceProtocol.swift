//
//  PageProfileNetworkServiceProtocol.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 02.09.2026.
//

import Foundation

@MainActor
protocol PageProfileNetworkServiceProtocol {
    func getMe(result: @escaping (Result<Components.Schemas.User, NetworkError>) -> Void)
    func getUser(id: Int, result: @escaping (Result<Components.Schemas.User, NetworkError>) -> Void)
    func getUsersPosts(page: Int, limit: Int, id: Int, result: @escaping (Result<Components.Schemas.PostPage, NetworkError>) -> Void)
}
