//
//  SignupViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 15.11.2024.
//

import UIKit

enum InputTextStatus {
    case usernameIsEmpty
    case passwordIsEmpty
    case registrationError
    case registrationSucceed
    case invalidUsername
    case invalidPassword
    
    var title: String {
        switch self {
        case .usernameIsEmpty: "Oops..."
        case .passwordIsEmpty: "Oops..."
        case .registrationError: "✗ Registration error"
        case .registrationSucceed: "✔︎ Great!"
        case .invalidUsername: "✗ Wrong format"
        case .invalidPassword: "✗ Wrong format"
        }
    }
    
    var message: String {
        switch self {
        case .usernameIsEmpty: 
            "Please enter your username"
        case .passwordIsEmpty: 
            "Please create a password"
        case .registrationError: 
            "A user with this name already exists. Please choose a different name"
        case .registrationSucceed: 
            "Your account has been created successfully"
        case .invalidUsername:
            """
                Please, use in your username only:
                 - latin letters (A-Z, a-z)
                 - numbers 0-9
                 - special symbols ("_", "-", ".")
            
                Minimum length of a username must be at least 4 characters, but not more than 20
                
                Don't use spaces in your username
            """
        case .invalidPassword:
            """
                Please, use in your password only:
                 - latin letters (A-Z, a-z)
                 - numbers 0-9
                 - special symbols ("!", "#", "$", "%", "^", "&", "*", "-", "_", "=", "+", ".", "/", "|")
            
                Minimum length of a password must be at least 8 characters
                
                Don't use spaces in your password
            """
        }
    }
}

final class SignupViewController: UIViewController {

    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    private let storageManager = StorageManager.shared
    private var userName = ""
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.delegate = self
        passwordTF.delegate = self
        userNameTF.becomeFirstResponder()
    }
    
    @IBAction func signupButtonPressed() {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let inputName = userNameTF.text, !inputName.isEmpty else {
            showAlert(withStatus: .usernameIsEmpty)
            return
        }
        
        if !isUsernameLengthValid(inputName) ||
            !isUsernameContainsNoWhitespaces(inputName) ||
            !isUsernamePatternValid(inputName) {
            showAlert(withStatus: .invalidUsername) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        if !checkUsername(inputName) {
            showAlert(withStatus: .registrationError)
        }
        
        guard let inputPassword = passwordTF.text, !inputPassword.isEmpty else {
            showAlert(withStatus: .passwordIsEmpty)
            return
        }
        
        if !isPasswordLengthValid(inputPassword) ||
            !isPasswordContainsNoWhitespaces(inputPassword) ||
            !isPasswordPatternValid(inputPassword) {
            showAlert(withStatus: .invalidPassword) { [unowned self] in 
                passwordTF.becomeFirstResponder()
            }
            return
        }
        
        let user = User(name: inputName, password: inputPassword)
        
        register(user: user)
        showAlert(withStatus: .registrationSucceed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            dismiss(animated: true)
        }
    }
    
    // MARK: - UIAlertController
    private func showAlert(withStatus status: InputTextStatus, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        if status != .registrationSucceed {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
            alert.addAction(okAction)
        }
        present(alert, animated: true)
    }
    
    // MARK: - Methods with StorageManager
    private func checkUsername(_ username: String) -> Bool {
        let users = storageManager.fetchUsers()
        
        if users.contains(where: { $0.name == username }) {
            return false
        }
        return true
    }
    
    private func register(user: User) {
        var users = storageManager.fetchUsers()
        
        users.append(user)
        storageManager.save(users: users)
    }
}


// MARK: - Username check
private extension SignupViewController {
    
    func isUsernameLengthValid(_ username: String) -> Bool {
        (4...20).contains(username.count)
    }
    
    func isUsernameContainsNoWhitespaces(_ username: String) -> Bool {
        username.rangeOfCharacter(from: .whitespaces) == nil
    }
    
    func isUsernamePatternValid(_ username: String) -> Bool {
        let regex = "^[a-zA-Z0-9._-]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }
}

// MARK: - Password check
private extension SignupViewController {
    func isPasswordLengthValid(_ password: String) -> Bool {
        password.count >= 8
    }
    
    func isPasswordContainsNoWhitespaces(_ password: String) -> Bool {
        password.rangeOfCharacter(from: .whitespaces) == nil
    }
    
    func isPasswordPatternValid(_ password: String) -> Bool {
        let regex = "^[a-zA-Z0-9!#$%^&*\\-_=+./|]+$"
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            return predicate.evaluate(with: password)

    }
}

// MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            signupButtonPressed()
        }
        return true
    }
}
