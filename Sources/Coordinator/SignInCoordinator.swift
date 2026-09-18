//
//  SignInCoordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 20.08.2026.
//

import UIKit

final class SignInCoordinator: CoordinatorProtocol {
    var childCoordinators: [any CoordinatorProtocol] = [] // always empty
    var navigationController: UINavigationController
    let coordinatorType: CoordinatorType = .signIn
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    let authService: any AuthServiceProtocol
    
    init(navigationController: UINavigationController, authService: AuthServiceProtocol = AuthService()) {
        self.navigationController = navigationController
        self.authService = authService
    }
    
    func start() {
        let authService = AuthService()
        let signInViewModel = SignInViewModel(authService: authService)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        navigationController.setViewControllers([signInViewController], animated: false)
        signInViewModel.onSignedIn = { [weak self] in
            self?.finish()
        }
    }
    
    deinit {
        print("SignIn Coordinator was deinitialized.")
    }
}
