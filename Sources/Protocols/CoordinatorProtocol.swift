//
//  Coordinator.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 15.07.2026.
//

import UIKit

@MainActor
protocol CoordinatorProtocol: AnyObject, Hashable {
    var childCoordinators: [any CoordinatorProtocol] { get set }
    var navigationController: UINavigationController { get set }
    var coordinatorType: CoordinatorType  { get }
    var finishDelegate: (any CoordinatorFinishDelegate)? { get set }
    func start()
    func finish()
}

extension CoordinatorProtocol {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    func finish() {
        finishDelegate?.coordinatorDidFinish(self)
    }
}

extension CoordinatorProtocol where Self: CoordinatorFinishDelegate {
    func startChild(_ child: any CoordinatorProtocol) {
        child.finishDelegate = self
        childCoordinators.append(child)
        child.start()
    }
}

enum CoordinatorType {
    case application
    case signIn
    case tabBar
    case feed
    case myProfile
}
