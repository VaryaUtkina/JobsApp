//
//  SceneDelegate.swift
//  JobsApp
//
//  Created by Варвара Уткина on 30.10.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
//        let window = UIWindow(windowScene: windowScene)
//        self.window = window

//        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let identifier = isLoggedIn ? "JobsViewController" : "LoginViewController"
//        
//        let rootViewController = storyboard.instantiateViewController(withIdentifier: identifier)
//        let navigationController = UINavigationController(rootViewController: rootViewController)
//        
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
//    func sceneWillEnterForeground(_ scene: UIScene) {
//        guard let window = window else { return }
//        window.makeKeyAndVisible()
//    }

}

