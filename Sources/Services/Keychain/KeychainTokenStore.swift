import Foundation

// adapter between network and Keychain
final class KeychainTokenStore: TokenStore, @unchecked Sendable {
    private let lock = NSLock()
    private var cachedToken: String?
    
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
    }

    func save(_ token: String) {
        do {
            try keychainService.writeString(string: token, key: .accessToken)
            lock.lock(); cachedToken = token; lock.unlock()
        } catch {
            print("Saving failed: \(error)")
        }
    }

    func load() -> String? {
        lock.lock()
        let token = cachedToken
        lock.unlock()
        if let token {
            return token
        }
        do {
            let token = try keychainService.readString(key: .accessToken)
            lock.lock(); cachedToken = token; lock.unlock()
            return token
        } catch KeychainError.itemNotFound {
            return nil
        } catch {
            print("Loading failed: \(error)")
            return nil
        }
    }

    func clear() {
        do {
            try keychainService.delete(key: .accessToken)
            lock.lock(); cachedToken = nil; lock.unlock()
        } catch {
            print("Deleting failed: \(error)")
        }
    }
}

// One shared API instance for the app, wired to the local server and the Keychain store.
enum AppAPI {
    static let tokenStore = KeychainTokenStore()
    static let client = API(
        baseURL: URL(string: "http://localhost:8080")!,
        store: tokenStore
    )
}
