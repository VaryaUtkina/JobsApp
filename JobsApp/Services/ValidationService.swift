//
//  ValidationService.swift
//  JobsApp
//
//  Created by Варвара Уткина on 18.12.2024.
//

import Foundation

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

final class ValidationService {
    
    func validateUsername(_ username: String) -> InputTextStatus? {
        if username.isEmpty {
            return .usernameIsEmpty
        }
        
        if !isUsernameLengthValid(username) {
            return .invalidUsername
        }
        
        if !isUsernameContainsNoWhitespaces(username) {
            return .invalidUsername
        }
        
        if !isUsernamePatternValid(username) {
            return .invalidUsername
        }
        return nil
    }
    
    func validatePassword(_ password: String) -> InputTextStatus? {
        if password.isEmpty {
            return .passwordIsEmpty
        }
        
        if !isPasswordLengthValid(password) {
            return .invalidPassword
        }
        
        if !isPasswordContainsNoWhitespaces(password) {
            return .invalidPassword
        }
        
        if !isPasswordPatternValid(password) {
            return .invalidPassword
        }
        return nil
    }
    // MARK: - Username check
    private func isUsernameLengthValid(_ username: String) -> Bool {
        (4...20).contains(username.count)
    }
    
    private func isUsernameContainsNoWhitespaces(_ username: String) -> Bool {
        username.rangeOfCharacter(from: .whitespaces) == nil
    }
    
    private func isUsernamePatternValid(_ username: String) -> Bool {
        let regex = "^[a-zA-Z0-9._-]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }
    
    // MARK: - Password check
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
