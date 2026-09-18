//
//  FeedPostTableViewCellViewModel.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 09.09.2026.
//

struct FeedPostTableViewCellViewModel: Hashable {
    let post: Components.Schemas.Post
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.post.id == rhs.post.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(post.id)
    }
}
