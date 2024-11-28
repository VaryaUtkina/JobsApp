//
//  SignupViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 15.11.2024.
//

import UIKit

final class SignupViewController: UIViewController {

    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    var delegate: SignupViewControllerDelegate?
    var theme: Theme!
    
    private let storageManager = StorageManager.shared
    private var userName = ""
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        updateTheme(theme)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTF.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func signupButtonPressed() {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let inputName = userNameTF.text, !inputName.isEmpty else {
            showAlert(withStatus: .usernameIsEmpty) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        if !isUsernameLengthValid(inputName) ||
            !isUsernameContainsNoWhitespaces(inputName) ||
            !isUsernamePatternValid(inputName) {
            Log.error("Ошибка при проверке данных")
            showAlert(withStatus: .invalidUsername) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        if !checkUsername(inputName) {
            Log.error("Ошибка при проверке данных")
            showAlert(withStatus: .registrationError) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        guard let inputPassword = passwordTF.text, !inputPassword.isEmpty else {
            Log.error("Ошибка при проверке данных")
            showAlert(withStatus: .passwordIsEmpty) { [unowned self] in
                passwordTF.becomeFirstResponder()
            }
            return
        }
        
        if !isPasswordLengthValid(inputPassword) ||
            !isPasswordContainsNoWhitespaces(inputPassword) ||
            !isPasswordPatternValid(inputPassword) {
            Log.error("Ошибка при проверке данных")
            showAlert(withStatus: .invalidPassword) { [unowned self] in
                passwordTF.becomeFirstResponder()
            }
            return
        }
        
        let user = User(name: inputName, password: inputPassword)
        
        Log.debug("Пользователь регистрируется: \(user)")
        register(user: user)
        delegate?.updateTF(user.name)
        showAlert(withStatus: .registrationSucceed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            view.endEditing(true)
            dismiss(animated: true)
            navigationController?.popViewController(animated: true)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == userNameTF else { return true }
        guard let inputText = textField.text as NSString? else { return true }
        let updatedText = inputText.replacingCharacters(in: range, with: string)
        if !isUsernameLengthValid(updatedText) ||
            !isUsernameContainsNoWhitespaces(updatedText) ||
            !isUsernamePatternValid(updatedText) {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
        return true
    }
}

// MARK: - InputTextStatus
extension SignupViewController {
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
            case .registrationError: "✘ Registration error"
            case .registrationSucceed: "✔︎ Great!"
            case .invalidUsername: "✘ Wrong format"
            case .invalidPassword: "✘ Wrong format"
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
}
