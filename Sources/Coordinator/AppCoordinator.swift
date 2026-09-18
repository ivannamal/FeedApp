//
//  MainCoordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 15.07.2026.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol, CoordinatorFinishDelegate {
    var childCoordinators = [any CoordinatorProtocol]()
    var navigationController: UINavigationController
    let coordinatorType: CoordinatorType = .application
    private let authService: any AuthServiceProtocol
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    private let keychainService: any KeychainServiceProtocol
    
    init(navigationController: UINavigationController, authService: any AuthServiceProtocol = AuthService(), keychainService: any KeychainServiceProtocol = KeychainService()) {
        self.navigationController = navigationController
        self.authService = authService
        self.keychainService = keychainService
    }
    
    func coordinatorDidFinish(_ child: any CoordinatorProtocol) {
        childCoordinators.removeAll(where: {$0 === child})
        switch child.coordinatorType {
        case .signIn:
            let tabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
            startChild(tabBarCoordinator)
        case .tabBar:
            authService.signOut()
            let signInCoordinator = SignInCoordinator(navigationController: navigationController)
            startChild(signInCoordinator)
        default:
            break
        }
    }
    
    func start() {
        do {
            _ = try keychainService.readString(key: .accessToken)
            let tabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
            startChild(tabBarCoordinator)
        } catch {
            print(error)
            let signInCoordinator = SignInCoordinator(navigationController: navigationController)
            startChild(signInCoordinator)
        }
    }
    
    
}
