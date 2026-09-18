//
//  FeedPostTableViewCell.swift
//  FeedApp
//
//  Created by Ivanna Malashchuk on 09.09.2026.
//

import UIKit

final class FeedPostTableViewCell: UITableViewCell {
    static var reuseIdentifier: String { String(describing: self) }
    private static let formatter = RelativeDateTimeFormatter()
    private let authorName = UILabel()
    private let authorImage = RemoteImageView()
    private let text = UILabel()
    private var postImage: RemoteImageView = RemoteImageView()
    private let likes = UILabel()
    private let createdAt = UILabel()
    private let shareBtn = UIButton()
    private let likeBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [authorName, createdAt])
        stack.axis = .vertical
        stack.spacing = 2
        let stack1 = UIStackView(arrangedSubviews: [authorImage, stack])
        stack1.axis = .horizontal
        stack1.spacing = 16
        let stack3 = UIStackView(arrangedSubviews: [shareBtn, likeBtn, UIView()])
        stack3.axis = .horizontal
        stack3.spacing = 20
        stack3.distribution = .fill
        let stack2 = UIStackView(arrangedSubviews: [makeSpacing(stack1), makeSpacing(text), postImage, makeSpacing(stack3)])
        stack2.axis = .vertical
        stack2.spacing = 13
        stack2.translatesAutoresizingMaskIntoConstraints = false
        if let descriptor = UIFont.preferredFont(forTextStyle: .body)
            .fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
            authorName.font = UIFont(descriptor: descriptor, size: 0)
        }
        authorImage.clipsToBounds = true
        authorImage.layer.cornerRadius = 10
        text.numberOfLines = 0
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        createdAt.textColor = .secondaryLabel
        createdAt.font = .preferredFont(forTextStyle: .caption1)
        shareBtn.setImage(UIImage(named: "shareBtn"), for: .normal)
        likeBtn.setImage(UIImage(named: "likeBtn"), for: .normal)
        contentView.addSubview(stack2)
        NSLayoutConstraint.activate([
            stack2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stack2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            authorImage.widthAnchor.constraint(equalToConstant: 50),
            authorImage.heightAnchor.constraint(equalTo: authorImage.widthAnchor),
            postImage.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: FeedPostTableViewCellViewModel) {
        authorName.text = model.post.author.displayName
        authorImage.setImage(from: model.post.author.avatarUrl)
        text.text = model.post.text
        if let image = model.post.imageUrl {
            postImage.setImage(from: image)
        } else {
            postImage.isHidden = true
        }
        likes.text = String(model.post.likes)
        createdAt.text = FeedPostTableViewCell.formatter.localizedString(for: model.post.createdAt, relativeTo: Date())
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorName.text = nil
        authorImage.image = nil
        text.text = nil
        postImage.image = nil
        likes.text = nil
        createdAt.text = nil
        postImage.isHidden = false
    }
    
    private func makeSpacing(_ view: UIView) -> UIView {
        let container = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
        ])
        return container
    }
}
