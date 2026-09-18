//
//  ProfileCoordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 26.08.2026.
//

import UIKit

final class ProfileCoordinator: CoordinatorProtocol {
    var childCoordinators: [any CoordinatorProtocol] = [] //always empty
    var navigationController: UINavigationController
    let coordinatorType: CoordinatorType = .myProfile
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = ProfileViewModel()
        let vc = ProfileViewController(profileViewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
        vc.onSignOut = { [weak self] in
            self?.finish()
        }
    }
    
    deinit {
        print("Profile Coordinator was deinitialized.")
    }
}
