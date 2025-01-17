//
//  SceneDelegate.swift
//  JobsApp
//
//  Created by Варвара Уткина on 30.10.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let storageManager = StorageManager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let isUserLoggedIn = storageManager.isUserLoggedIn()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if isUserLoggedIn {
            guard let user = storageManager.fetchUser() else {
                Log.error("Пользователь не найден")
                return
            }
            if let jobsVC = storyboard.instantiateViewController(withIdentifier: "JobsViewController") as? JobsViewController {
                jobsVC.user = user
                jobsVC.theme = storageManager.fetchTheme()
                
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                jobsVC.logoutDelegate = loginVC
                
                window.rootViewController = UINavigationController(rootViewController: jobsVC)
            }
        } else {
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window.rootViewController = UINavigationController(rootViewController: rootViewController)
        }
        
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

