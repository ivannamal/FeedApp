//
//  BaseViewController.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 05.08.2026.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController, ProgressShowable {

    private var progressHUD: JGProgressHUD?

    func showProgress(_ title: String?) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = title ?? "Loading..."
        hud.textLabel.textColor = .white
        progressHUD = hud
        hud.show(in: view, animated: true)
    }

    func hideProgress(completion: VoidClosure?) {
        progressHUD?.dismiss(animated: true)
        progressHUD = nil
        completion?()
    }
}
