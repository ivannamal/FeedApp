//
//  ProfileViewModel.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 26.08.2026.
//

import Foundation

@MainActor
final class ProfileViewModel {
    private(set) var me: Components.Schemas.User?
    private(set) var postModels: [FeedPostTableViewCellViewModel] = []
    var onChange: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadMore: (() -> Void)?
    private var isLoading = false
    private var currentPage = 0
    private var total = 0
    private let service: any PageProfileNetworkServiceProtocol
    
    init(service: any PageProfileNetworkServiceProtocol = PageProfileNetworkService()) {
        self.service = service
    }
    
    func load() {
        service.getMe{result in
            switch result {
            case .success(let user):
                self.me = user
                self.loadPosts()
                self.onChange?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func loadPosts(limit: Int = 1) {
        guard let me = me else { return }
        if !isLoading && (currentPage == 0 || postModels.count < total) {
            isLoading = true
            if currentPage > 0 { onLoadMore?() }
            service.getUsersPosts(page: currentPage + 1, limit: limit, id: me.id, result: { result in
                self.isLoading = false
                switch result {
                case .success(let posts):
                    self.currentPage = self.currentPage + 1
                    self.total = posts.total
                    self.postModels += posts.posts.map { return FeedPostTableViewCellViewModel(post: $0) }
                    self.onChange?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            })
        }
    }
    
    func loadNextPage() {
        loadPosts()
}
    
    var profileHeaderModel: ProfileHeaderViewModel? {
        guard let me else { return nil }
        return ProfileHeaderViewModel(name: me.displayName, bio: me.bio, photo: me.avatarUrl)
    }
    
    func reload() {
        currentPage = 0
        total = 0
        postModels = []
        load()
    }
}
