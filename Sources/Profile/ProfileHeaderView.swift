//
//  ProfileHeaderView.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 07.09.2026.
//

import UIKit

final class ProfileHeaderView: UIView {
    private let profilePhoto: RemoteImageView = RemoteImageView()
    private let name: UILabel = UILabel()
    private let bio: UITextView = UITextView()
    private let banner: ProfileBannerView = ProfileBannerView()
    private let myPhotoAlbumsLabel = UILabel()
    private let tabs = UISegmentedControl(items: ["Timeline posts", "Profile pictures", "Instagram photos"])
    var onSignOut: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: ProfileHeaderViewModel) {
        name.text = model.name
        bio.text = model.bio
        profilePhoto.setImage(from: model.photo)
        banner.updateBanner(with: model.banner)
    }
    
    private func setUpLayout() {
        backgroundColor = .systemBackground
        profilePhoto.layer.cornerRadius = 25
        profilePhoto.clipsToBounds = true
        profilePhoto.backgroundColor = .tertiarySystemFill
        profilePhoto.contentMode = .scaleAspectFill
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        profilePhoto.layer.borderWidth = 4
        profilePhoto.layer.borderColor = UIColor.white.cgColor
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.onSignOut = { [weak self] in self?.onSignOut?() }
        
        name.font = .preferredFont(forTextStyle: .title2)
        name.textAlignment = .left
        bio.font = .preferredFont(forTextStyle: .body)
        bio.textColor = .label
        bio.isScrollEnabled = false
        bio.textContainerInset = .zero
        bio.textContainer.lineFragmentPadding = 0
        bio.isEditable = false
        bio.dataDetectorTypes = [.link, .phoneNumber]
        
        let stack = UIStackView(arrangedSubviews: [name, bio])
        stack.axis = .vertical
        stack.spacing = 11
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        myPhotoAlbumsLabel.text = "My Photo Albums"
        myPhotoAlbumsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tabs.selectedSegmentIndex = 0
        tabs.apportionsSegmentWidthsByContent = true
        tabs.translatesAutoresizingMaskIntoConstraints = false
        addSubview(banner)
        addSubview(profilePhoto)
        addSubview(stack)
        addSubview(myPhotoAlbumsLabel)
        addSubview(tabs)
        NSLayoutConstraint.activate([
            profilePhoto.heightAnchor.constraint(equalToConstant: 180),
            profilePhoto.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePhoto.centerYAnchor.constraint(equalTo: banner.bottomAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 180),
            stack.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 15),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -27),
            banner.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            banner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            banner.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            myPhotoAlbumsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            myPhotoAlbumsLabel.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 27),
            tabs.centerXAnchor.constraint(equalTo: centerXAnchor),
            tabs.topAnchor.constraint(equalTo: myPhotoAlbumsLabel.bottomAnchor, constant: 12),
            tabs.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
        ])
    }
}

struct ProfileHeaderViewModel {
    let name: String
    let bio: String?
    let photo: String
    let banner: String = "https://picsum.photos/id/1015/1170/750"
}
