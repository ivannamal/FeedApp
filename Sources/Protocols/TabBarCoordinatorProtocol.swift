//
//  TabBarCoordinatorProtocol.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

import UIKit

protocol TabBarCoordinatorProtocol: CoordinatorProtocol {
    var tabBarController: UITabBarController { get }
}

enum Tab: Int {
    case feed, profile
    var title: String {
        switch self {
        case .feed: "Feed"
        case .profile: "Profile"
        }
    }
    var image: UIImage? {
        switch self {
        case .feed: return UIImage(systemName: "list.bullet")
        case .profile: return UIImage(systemName: "person")
        }
    }
}
