import UIKit
import RouteComposer

// MARK: - Scene Delegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        let step = ApplicationConfiguration.stepToHome
        var buttons: [PinEntryModel.Button] = (1...9).map { index in
                .init(title: "\(index)", action: .add(index))
        }
        buttons.append(.init(title: "E", action: .removeLast))
        buttons.append(.init(title: "0"))
        buttons.append(.init(title: "⌫", action: .removeLast))

        

        let keypad = PinEntryModel.KeypadView(buttons: buttons)
        let model = PinEntryModel(enteredDigits: [], requiredPinLength: 4, keypadView: keypad, indicatorView: PinEntryModel.IndicatorView())

        try? DefaultRouter().navigate(to: Destination(to: step, with: model))
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        PinCodeService.shared.sceneWillEnterForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        PinCodeService.shared.sceneDidEnterBackground()
    }
}

