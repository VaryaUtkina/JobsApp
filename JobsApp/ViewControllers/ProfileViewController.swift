//
//  ProfileViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 10.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var profileView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    
    // MARK: - Public Properties
    var user: User!
    var theme: Theme! {
        didSet {
            updateCustomTheme(theme)
        }
    }
    weak var delegate: ThemeDelegate?
    weak var updateDelegate: UserUpdateDelegate?
    
    // MARK: - Private Properties
    private var securityIsOn = true
    private let validation = ValidationService.shared
    private let storageManager = StorageManager.shared
    
    private var okButton: UIAlertAction?
    private weak var presentedAlertController: UIAlertController?
    
    private var isUsernameValid = false
    private var isPasswordValid = false
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCustomTheme(theme)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateDelegate?.update(user: user)
    }

    @IBAction func moonButtonAction(_ sender: UIBarButtonItem) {
        theme = super.changeTheme(theme, withDelegate: delegate)
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
    
    @IBAction func editAction() {
        editUser()
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
    
    @IBAction func deleteProfileAction() {
        deleteProfile()
    }
    
    private func setupUI() {
        setupView()
        updateUI()
        navigationController?.navigationBar.tintColor = .labelGrey
    }
    
    private func setupView() {
        profileView.backgroundColor = .customView
        profileView.layer.cornerRadius = 20
        
        profileView.layer.shadowRadius = 8
        profileView.layer.shadowOpacity = 0.6
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func showPassword() {
        let originalText = user.password
        passwordLabel.text = securityIsOn
        ? String(repeating: "•", count: originalText.count)
        : originalText
    }
    
    private func updateCustomTheme(_ theme: Theme) {
        super.updateTheme(theme)
        guard let buttonItems = navigationItem.rightBarButtonItems else {
            Log.error("No button item")
            return
        }
        for button in buttonItems {
            if button.tag == 0 {
                button.image = theme == .light
                ? UIImage(systemName: "moon")
                : UIImage(systemName: "moon.fill")
            }
        }
    }
    
    private func editUser() {
        let alert = UIAlertController(
            title: "Edit section",
            message: "Please, enter new Username and password",
            preferredStyle: .alert
        )
        
        alert.addTextField { [unowned self] textField in
            textField.text = user.name
            textField.placeholder = "Enter new Username"
            
            textField.addTarget(
                self,
                action: #selector(usernameDidChange(_:)),
                for: .allEvents
            )
        }
        
        alert.addTextField { [unowned self] textField in
            textField.text = user.password
            textField.placeholder = "Enter new password"
            
            textField.addTarget(
                self,
                action: #selector(passwordDidChange(_:)),
                for: .editingChanged
            )
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            if let name = alert.textFields?.first?.text,
               let password = alert.textFields?.last?.text {
                let editedUser = User(name: name, password: password)
                storageManager.edit(user: user, with: editedUser)
                user = editedUser
                updateUI()
            }
        }
        
        okAction.isEnabled = false
        okButton = okAction
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        presentedAlertController = alert
    }
    
    private func deleteProfile() {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "You are going to delete your Profile",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            storageManager.delete(user: user)
            logoutAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func updateButton() {
        okButton?.isEnabled = isPasswordValid && isUsernameValid
    }
    
    private func updateUI() {
        usernameLabel.text = user.name
        showPassword()
    }
    
    @objc private func usernameDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if validation.validateUsername(text) != nil {
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.red.cgColor
                isUsernameValid = false
            } else {
                textField.layer.borderWidth = 0
                textField.layer.borderColor = nil
                if text == user.name {
                    isUsernameValid = true
                } else {
                    isUsernameValid = validation.checkUsername(text)
                }
            }
            updateButton()
        }
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if validation.validatePassword(text) != nil {
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor.red.cgColor
                isPasswordValid = false
            } else {
                textField.layer.borderWidth = 0
                textField.layer.borderColor = nil
                isPasswordValid = true
            }
            updateButton()
        }
    }
}







// MARK: - Initializers





// MARK: - IB Actions

// MARK: - Public Methods

// MARK: - Private Methods
