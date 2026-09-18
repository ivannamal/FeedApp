//
//  ProfileBannerView.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 09.09.2026.
//

import UIKit

final class ProfileBannerView: UIView {
    private let photoBanner: RemoteImageView = RemoteImageView()
    private let signOutButton: UIButton = UIButton(type: .system)
    var onSignOut: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBanner(with url: String) {
        photoBanner.setImage(from: url)
    }
    private func setUpLayout() {
        photoBanner.translatesAutoresizingMaskIntoConstraints = false
        photoBanner.contentMode = .scaleAspectFill
        photoBanner.clipsToBounds = true
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setImage(UIImage(named: "Logout"), for: .normal)
        signOutButton.tintColor = .white
        signOutButton.imageView?.contentMode = .scaleAspectFit
        signOutButton.addAction(UIAction { [weak self] _ in
            self?.onSignOut?()
        }, for: .touchUpInside)
        addSubview(photoBanner)
        addSubview(signOutButton)
        NSLayoutConstraint.activate([
            photoBanner.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            photoBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoBanner.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 250/390),
            photoBanner.bottomAnchor.constraint(equalTo: bottomAnchor),
            signOutButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 28),
            signOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            signOutButton.widthAnchor.constraint(equalToConstant: 44),
            signOutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
