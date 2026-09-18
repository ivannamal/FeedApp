//
//  FeedPostsNetworkServiceProtocol.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 09.09.2026.
//

@MainActor
protocol FeedPostsNetworkServiceProtocol {
    func getPostsList(page: Int, limit: Int, result: @escaping (Result<Components.Schemas.PostPage, NetworkError>) -> Void)
}
