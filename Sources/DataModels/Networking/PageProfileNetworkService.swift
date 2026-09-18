//
//  PageProfileNetworkService.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 02.09.2026.
//
import Foundation

@MainActor
final class PageProfileNetworkService: PageProfileNetworkServiceProtocol {
    private let api: API
    
    nonisolated init(api: API = AppAPI.client) {
        self.api = api
    }
    
    func getMe(result: @escaping (Result<Components.Schemas.User, NetworkError>) -> Void) {
        Task{
            do{
                let me = try await api.currentUser()
                result(.success(me))
            } catch {
                result(.failure(NetworkError(error: error)))
            }
        }
    }
    
    func getUser(id: Int, result: @escaping (Result<Components.Schemas.User, NetworkError>) -> Void) {
        Task{
            do{
                let user = try await api.user(id: id)
                result(.success(user))
            } catch {
                result(.failure(NetworkError(error: error)))
            }
        }
    }
    
    func getUsersPosts(page: Int, limit: Int, id: Int, result: @escaping (Result<Components.Schemas.PostPage, NetworkError>) -> Void) {
        Task {
            do {
                let posts = try await api.posts(ofUser: id, page: page, limit: limit)
                result(.success(posts))
            } catch {
                result(.failure(NetworkError(error: error)))
            }
        }
    }
}
