//
//  SignupPresenter.swift
//  JobsApp
//
//  Created by Варвара Уткина on 05.02.2025.
//

import UIKit

protocol SignupPresenterDelegate: AnyObject {
    func presentAlert(title: String, message: String, isRegistrationSucceed: Bool, completion: (() -> Void)?)
}

typealias PresenterDelegate = SignupPresenterDelegate & UIViewController

final class SignupPresenter {
    
    weak var delegate: PresenterDelegate?
    
    private let storageManager = StorageManager.shared
    
    func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(withStatus status: InputTextStatus, completion: (() -> Void)? = nil) {
        let registrationStatus = status == .registrationSucceed
        delegate?.presentAlert(
            title: status.title,
            message: status.message,
            isRegistrationSucceed: registrationStatus,
            completion: completion
        )
    }
    
    func register(user: User) {
        var users = storageManager.fetchUsers()
        users.append(user)
        storageManager.save(users: users)
    }
}
