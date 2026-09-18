//
//  ProgressShowable.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

typealias VoidClosure = () -> Void

protocol ProgressShowable {

   func showProgress(_ title: String?)

   func hideProgress(completion: VoidClosure?)

}
