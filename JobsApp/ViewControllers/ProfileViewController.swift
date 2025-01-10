//
//  ProfileViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 10.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    @IBOutlet var profileView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    // TODO: - put moon button and setup theme
    
    private var securityIsOn = true
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    private func setupUI() {
        setupView()
        usernameLabel.text = user.name
        showPassword()
    }
    
    private func showPassword() {
        let originalText = user.password
        passwordLabel.text = securityIsOn
        ? String(repeating: "•", count: originalText.count)
        : originalText
    }
    
    private func setupView() {
        profileView.backgroundColor = .customView
        profileView.layer.cornerRadius = 20
        
        profileView.layer.shadowRadius = 8
        profileView.layer.shadowOpacity = 0.6
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

    @IBAction func eyeAction(_ sender: UIButton) {
        securityIsOn.toggle()
        sender.setImage(
            securityIsOn
            ? UIImage(systemName: "eye.slash.fill")
            : UIImage(systemName: "eye.fill"),
            for: .normal
        )
        showPassword()
    }
    
    // TODO: - edit button
    @IBAction func editAction() {
        
    }

    @IBAction func logoutAction() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window.rootViewController = UINavigationController(rootViewController: rootVC)
            window.makeKeyAndVisible()
        }
    }
}
