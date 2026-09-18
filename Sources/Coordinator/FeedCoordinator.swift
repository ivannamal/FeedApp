//
//  FeedCoordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 26.08.2026.
//

import UIKit

final class FeedCoordinator: CoordinatorProtocol {
    var childCoordinators: [any CoordinatorProtocol] = []
    var navigationController: UINavigationController
    let coordinatorType: CoordinatorType = .feed
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FeedViewController()
        navigationController.setViewControllers([vc], animated: false)
    }
    
    deinit {
        print("Feed Coordinator was deinitialized.")
    }
}
