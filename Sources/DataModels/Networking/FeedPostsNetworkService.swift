//
//  FeedPostsNetworkService.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 09.09.2026.
//

@MainActor
final class FeedPostsNetworkService: FeedPostsNetworkServiceProtocol {
    private let api: API
    
    nonisolated init(api: API = AppAPI.client) {
        self.api = api
    }
    
    func getPostsList(page: Int, limit: Int, result: @escaping (Result<Components.Schemas.PostPage, NetworkError>) -> Void) {
        Task{
            do{
                let posts = try await api.feed(page: page, limit: limit)
                result(.success(posts))
            } catch {
                result(.failure(NetworkError(error: error)))
            }
        }
    }
}
