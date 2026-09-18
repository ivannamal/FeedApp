import UIKit

final class SignInViewController: BaseViewController {
    private let viewModel: SignInViewModel
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let signInButton = UIButton(type: .system)
    private let errorLabel = UILabel()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        setUpViews()
        bind()
    }

    private func setUpViews() {
        usernameField.placeholder = "Username (try emily)"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no

        passwordField.placeholder = "Password (try pass)"
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true

        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.font = .preferredFont(forTextStyle: .footnote)

        let logo = UILabel()
        logo.font = .systemFont(ofSize: 40, weight: .bold)
        logo.textColor = .blue
        logo.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [logo, usernameField, passwordField, signInButton, errorLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.setCustomSpacing(28, after: logo)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

    private func bind() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            switch state {
            case .idle:
                self.errorLabel.text = nil
                hideProgress(completion: nil)
                self.signInButton.isEnabled = true
            case .loading:
                self.errorLabel.text = nil
                showProgress("Signing in...")
                self.signInButton.isEnabled = false
            case .failed(let message):
                self.errorLabel.text = message
                hideProgress(completion: nil)
                self.signInButton.isEnabled = true
            case .signedIn:
                hideProgress(completion: nil)
            }
        }
    }

    @objc private func didTapSignIn() {
        Task { [weak self] in
            guard let self else {
                return
            }
            await viewModel.signIn(username: usernameField.text ?? "", password: passwordField.text ?? "")
        }
    }
}
