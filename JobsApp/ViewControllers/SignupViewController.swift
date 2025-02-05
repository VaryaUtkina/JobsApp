//
//  SignupViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 15.11.2024.
//

import UIKit

final class SignupViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    // MARK: - Public Properties
    var delegate: SignupViewControllerDelegate?
    var theme: Theme!
    
    // MARK: - Private Properties
    private let presenter = SignupPresenter()
    
    private let storageManager = StorageManager.shared
    private let validation = ValidationService.shared
    private var userName = ""
    private var password = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .labelGrey
        
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        updateTheme(theme)
        presenter.setViewDelegate(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTF.becomeFirstResponder()
    }
    
    // MARK: - Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func signupButtonPressed() {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        guard let inputName = userNameTF.text else { return }
        
        if let usernameError = validation.validateUsername(inputName) {
            presenter.showAlert(withStatus: usernameError) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        if !validation.checkUsername(inputName) {
            presenter.showAlert(withStatus: .registrationError) { [unowned self] in
                userNameTF.becomeFirstResponder()
            }
            return
        }
        
        guard let inputPassword = passwordTF.text else { return }
        
        if let passwordError = validation.validatePassword(inputPassword) {
            presenter.showAlert(withStatus: passwordError) { [unowned self] in
                passwordTF.becomeFirstResponder()
            }
            return
        }
        
        let user = User(name: inputName, password: inputPassword)
        presenter.register(user: user)
        
        delegate?.updateTF(user.name)
        presenter.showAlert(withStatus: .registrationSucceed)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            view.endEditing(true)
            dismiss(animated: true)
            navigationController?.popViewController(animated: true)
        }
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
        if validation.validateUsername(updatedText) != nil {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.red.cgColor
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
        return true
    }
}


extension SignupViewController: SignupPresenterDelegate {
    func presentAlert(title: String, message: String, isRegistrationSucceed: Bool, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if !isRegistrationSucceed {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion?()
            }
            alert.addAction(okAction)
        }
        present(alert, animated: true)
    }
}

