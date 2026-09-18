import UIKit

final class FeedViewController: UITableViewController{
    private let viewModel = FeedViewModel()
    let spinner = UIActivityIndicatorView(style: .medium)
    let refresh = UIRefreshControl()
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: FeedPostTableViewCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.backgroundColor = .systemGroupedBackground
        refresh.attributedTitle = NSAttributedString(string: "Loading Feed Posts...")
        tableView.refreshControl = refresh
        tableView.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        spinner.startAnimating()
        viewModel.onLoadMore = { [weak self] in
            self?.tableView.tableFooterView = self?.spinner
        }
        viewModel.onChange = { [weak self] in
            self?.tableView.tableFooterView = nil
            self?.tableView.refreshControl?.endRefreshing()
            self?.applySnapshot()
        }
        viewModel.onError = { [weak self] message in
            self?.tableView.tableFooterView = nil
            self?.tableView.refreshControl?.endRefreshing()
            self?.present(alert(message), animated: true)
        }
        viewModel.load()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y + scrollView.frame.size.height
        if position > scrollView.contentSize.height * 0.9 {
            viewModel.load()
        }
    }
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, FeedPostTableViewCellViewModel>(tableView: tableView) {tableView,indexPath, model in
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.reuseIdentifier, for: indexPath) as! FeedPostTableViewCell
        cell.update(with: model)
        return cell
    }
    
    @objc private func reload() { viewModel.reload() }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedPostTableViewCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.postModels, toSection: .main)
        dataSource.apply(snapshot)
    }
}

@MainActor
func alert(_ message: String) -> UIAlertController {
    let a = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    a.addAction(UIAlertAction(title: "OK", style: .default))
    return a
}
