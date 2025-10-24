//
//  SceneDelegate.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: HoldingsViewController())
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}

