//
//  MainTabBarCoordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

import UIKit

final class MainTabBarCoordinator: TabBarCoordinatorProtocol, CoordinatorFinishDelegate {
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    let tabBarController: UITabBarController = UITabBarController()
    var childCoordinators = [any CoordinatorProtocol]()
    var navigationController: UINavigationController
    let coordinatorType: CoordinatorType = .tabBar
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feed = FeedCoordinator()
        let profile = ProfileCoordinator()
        startChild(feed)
        startChild(profile)
        let feedNav = feed.navigationController
        feedNav.tabBarItem = UITabBarItem(title: Tab.feed.title, image: Tab.feed.image, tag: Tab.feed.rawValue)
        let profileNav = profile.navigationController
        profileNav.tabBarItem = UITabBarItem(title: Tab.profile.title, image: Tab.profile.image, tag: Tab.profile.rawValue)
        tabBarController.viewControllers = [feedNav, profileNav]
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    func coordinatorDidFinish(_ child: any CoordinatorProtocol) {
        switch child.coordinatorType {
        case .myProfile: self.finish()
        case .application:
            break
        case .signIn:
            break
        case .tabBar:
            break
        case .feed:
            break
        }
    }
    
    deinit {
        print("TabBar was deinitialized.")
    }
}
