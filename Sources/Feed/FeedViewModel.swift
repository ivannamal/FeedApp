import Foundation

@MainActor
final class FeedViewModel {
    private(set) var postModels: [FeedPostTableViewCellViewModel] = []
    var onChange: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadMore: (() -> Void)?
    private let feedPostNetworkService: any FeedPostsNetworkServiceProtocol
    private var isLoading = false
    private var currentPage = 0
    private var total = 0
    
    init(feedPostNetworkService: any FeedPostsNetworkServiceProtocol = FeedPostsNetworkService()) {
        self.feedPostNetworkService = feedPostNetworkService
    }
    
    func load(limit: Int = 3) {
        if !isLoading && (currentPage == 0 || postModels.count < total) {
            isLoading = true
            if currentPage > 0 { onLoadMore?() }
            feedPostNetworkService.getPostsList(page: currentPage + 1, limit: limit) { result in
                self.isLoading = false
                switch result {
                case .success(let page):
                    self.currentPage = self.currentPage + 1
                    self.total = page.total
                    self.postModels += page.posts.map { return FeedPostTableViewCellViewModel(post: $0) }
                    self.onChange?()
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func reload() {
        currentPage = 0
        total = 0
        postModels = []
        load()
    }
}
