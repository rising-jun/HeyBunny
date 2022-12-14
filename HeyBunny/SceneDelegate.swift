//
//  SceneDelegate.swift
//  HeyBunny
//
//  Created by 김동준 on 2022/09/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let dependencyInject = DependencyInjector()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneWindow)
        let bunnyView = BunnyViewController()
        bunnyView.dependency = dependencyInject.injectBunnyDependency()
        window.rootViewController = bunnyView
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}

