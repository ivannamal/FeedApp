import UIKit

final class ProfileViewController: UITableViewController {
    var onSignOut: (() -> Void)?
    private let profileViewModel: ProfileViewModel
    private let profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    let spinner = UIActivityIndicatorView(style: .medium)
    let refresh = UIRefreshControl()
    
    private enum Section {
        case main
    }
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh.attributedTitle = NSAttributedString(string: "Loading My Posts...")
        tableView.refreshControl = refresh
        tableView.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        tableView.tableHeaderView = profileHeaderView
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.reuseIdentifier)
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        spinner.startAnimating()
        profileHeaderView.onSignOut = { [weak self] in
            self?.onSignOut?()
        }
        profileViewModel.onLoadMore = { [weak self] in
            self?.tableView.tableFooterView = self?.spinner
        }
        profileViewModel.onChange = { [weak self] in
            guard let self else { return }
            self.tableView.tableFooterView = nil
            self.tableView.refreshControl?.endRefreshing()
            guard let model = profileViewModel.profileHeaderModel else { return }
            profileHeaderView.update(model: model)
            self.applySnapshot()
        }
        profileViewModel.onError = { [weak self] message in
            self?.tableView.tableFooterView = nil
            self?.tableView.refreshControl?.endRefreshing()
            self?.present(alert(message), animated: true)
        }
        profileViewModel.load()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.contentSize.height > 0 else { return }
        let position = scrollView.contentOffset.y + scrollView.frame.size.height
        if position > scrollView.contentSize.height * 0.9 {
            profileViewModel.loadNextPage()
        }
    }
    
    @objc private func reload() { profileViewModel.reload() }
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, FeedPostTableViewCellViewModel>(tableView: tableView) {tableView,indexPath, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.reuseIdentifier, for: indexPath) as! FeedPostTableViewCell
        cell.update(with: model)
        return cell
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedPostTableViewCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(profileViewModel.postModels, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        let size = header.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        let newHeight = ceil(size.height)
        if abs(header.frame.height - newHeight) > 0.5 {
            header.frame.size.height = newHeight
            tableView.tableHeaderView = header
        }
    }
}
