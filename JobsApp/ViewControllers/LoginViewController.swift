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
    
    @IBOutlet var usernameTF: UITextField!
    
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signupVC = segue.destination as? SignupViewController else { return }
        signupVC.delegate = self
    }

    @IBAction func loginButtonAction() {
    }
    @IBAction func signupButtonAction() {
    }
    @IBAction func forgotButtonAction() {
    }
}

// MARK: - SignupViewControllerDelegate
extension LoginViewController: SignupViewControllerDelegate {
    func updateTF(_ text: String) {
        usernameTF.text = text
    }
}
