//
//  LoginViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 11.11.2024.
//

import UIKit

protocol SignupViewControllerDelegate: AnyObject {
    func updateTF(_ text: String)
}

final class LoginViewController: UIViewController {
    
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    lazy private var eyeButton: UIButton = {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .labelGrey
         
        eyeButton.addTarget(
            self,
            action: #selector(togglePasswordVisibility),
            for: .touchUpInside
        )
        eyeButton.isEnabled = false
        return eyeButton
    }()
    
    private let storageManager = StorageManager.shared
    private var isPrivate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        passwordTF.rightView = eyeButton
        passwordTF.rightViewMode = .always
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signupVC = segue.destination as? SignupViewController else { return }
        signupVC.delegate = self
    }

    @IBAction func loginButtonAction() {
    }
    @IBAction func forgotButtonAction() {
        showAlert(for: .getPassword) { [weak self] user in
            guard let self else { return }
            if let user {
                showAlert(for: .simpleOK(message: "Your password: \(user.password)"))
            } else {
                showAlert(for: .tryAgain)
            }
        }
    }
    
    @objc func togglePasswordVisibility(sender: UIButton) {
        let imageName = isPrivate ? "eye" : "eye.slash"
        
        passwordTF.isSecureTextEntry.toggle()
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        isPrivate.toggle()
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTF {
            userNameTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = passwordTF.text else { return }
        eyeButton.isEnabled = !text.isEmpty
    }
}

// MARK: - SignupViewControllerDelegate
extension LoginViewController: SignupViewControllerDelegate {
    func updateTF(_ text: String) {
        userNameTF.text = text
    }
}

// MARK: - AlertController
private extension LoginViewController {
    enum AlertType {
        case getPassword
        case simpleOK(message: String)
        case tryAgain
        
        var configuration: (
            title: String,
            message: String,
            actions: [UIAlertAction],
            textFieldNeeded: Bool
        ) {
            switch self {
            case .getPassword:
                (
                    title: "Forgot password?",
                    message: "Please, enter your Username",
                    actions: [
                        UIAlertAction(title: "Get password", style: .default),
                        UIAlertAction(title: "Cancel", style: .destructive)
                    ],
                    textFieldNeeded: true
                )
            case .simpleOK(let message):
                (
                    title: "✔︎ User was found",
                    message: message,
                    actions: [
                        UIAlertAction(title: "OK", style: .default)
                    ],
                    textFieldNeeded: false
                )
            case .tryAgain:
                (
                    title: "✘ User wasn't found",
                    message: "Please, enter correct Username or create new account",
                    actions: [
                        UIAlertAction(title: "Try again", style: .default),
                        UIAlertAction(title: "Cancel", style: .destructive)
                    ],
                    textFieldNeeded: false
                )
            }
        }
    }
    
    func showAlert(for type: AlertType, completion: ((User?) -> Void)? = nil) {
        let config = type.configuration
        let alert = UIAlertController(title: config.title, message: config.message, preferredStyle: .alert)
        if config.textFieldNeeded {
            alert.addTextField { textField in
                textField.placeholder = "Enter your UserName"
            }
        }
        
        for action in config.actions {
            alert.addAction(createAction(action, alert: alert, completion: completion))
        }
        present(alert, animated: true)
    }
    
    func createAction(
        _ action: UIAlertAction,
        alert: UIAlertController,
        completion: ((User?) -> Void)?
    ) -> UIAlertAction {
        let handler: (UIAlertAction) -> Void
        
        switch action.title {
        case "Try again": handler = { [weak self] _ in
            guard let self = self else { return }
            showAlert(for: .getPassword) { [weak self] user in
                guard let self else { return }
                if let user {
                    showAlert(for: .simpleOK(message: "Your password: \(user.password)"))
                } else {
                    showAlert(for: .tryAgain)
                }
            }
        }
        case "Get password": handler = { [weak self] _ in
            guard let self = self else { return }
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                completion?(nil)
                return
            }
            let user = storageManager.findUser(withUsername: text)
            completion?(user)
        }
        default: handler = { _ in }
        }
        return UIAlertAction(title: action.title, style: action.style, handler: handler)
    }
}
