//
//  CoordinatorFinishDelegate.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 20.08.2026.
//

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish (_ child: any CoordinatorProtocol)
}
