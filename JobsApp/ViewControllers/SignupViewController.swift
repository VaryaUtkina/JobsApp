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
    private let validation = ValidationService()
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
        
        guard let inputName = userNameTF.text else { return }
        
        if let usernameError = validation.validateUsername(inputName) {
            showAlert(withStatus: usernameError) { [unowned self] in
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
        
        guard let inputPassword = passwordTF.text else { return }
        
        if let passwordError = validation.validatePassword(inputPassword) {
            showAlert(withStatus: passwordError) { [unowned self] in
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
        if let usernameError = validation.validateUsername(updatedText) {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
        return true
    }
}

