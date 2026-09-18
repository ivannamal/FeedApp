import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()
        self.window = window
        window.tintColor = .blue
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
