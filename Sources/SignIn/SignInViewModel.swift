import Foundation

@MainActor
final class SignInViewModel {
    
    private let authService: AuthServiceProtocol
    private let keychainService: KeychainServiceProtocol
    
    init(authService: AuthServiceProtocol, keychainService: KeychainServiceProtocol = KeychainService()) {
        self.authService = authService
        self.keychainService = keychainService
    }
    
    enum State: Equatable {
        case idle
        case loading
        case failed(String)
        case signedIn
    }
    
    private(set) var state: State = .idle {
        didSet { onStateChange?(state) }
    }
    var onStateChange: ((State) -> Void)?
    var onSignedIn: (() -> Void)?
    
    func signIn(username: String, password: String) async {
        state = .loading
        do {
            try await authService.signIn(username: username, password: password)
            state = .signedIn
            onSignedIn?()
            do {
                let date = Date()
                try keychainService.writeDate(date: date, key: .tokenIssueDate)
            } catch {
                print("Error while writing date: \(error)")
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
