//
//  StorageManager.swift
//  JobsApp
//
//  Created by Варвара Уткина on 05.11.2024.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "theme"
    private let userKey = "users"
    
    private init() {}
    
    func fetchTheme() -> Theme {
        guard let data = userDefaults.data(forKey: themeKey) else {
            Log.debug("Данные для 'themeKey' не найдены. Используется тема по умолчанию: .light")
            return .light
        }
        guard let theme = try? JSONDecoder().decode(Theme.self, from: data) else {
            Log.error("Ошибка декодирования темы")
            return .light }
        return theme
    }
    
    func save(theme: Theme) {
        guard let data = try? JSONEncoder().encode(theme) else {
            Log.error("Ошибка кодирования темы для сохранения")
            return
        }
        userDefaults.set(data, forKey: themeKey)
    }
    
    func fetchUsers() -> [User] {
        guard let data = userDefaults.data(forKey: userKey) else { return [] }
        guard let users = try? JSONDecoder().decode([User].self, from: data) else {
            Log.error("Ошибка декодирования списка пользователей")
            return []
        }
        return users
    }
    
    func save(users: [User]) {
        guard let data = try? JSONEncoder().encode(users) else {
            Log.error("Ошибка кодирования списка пользователей для сохранения")
            return
        }
        userDefaults.set(data, forKey: userKey)
        Log.debug("Сохранены пользователи: \(users)")
    }
    
    func edit(user: User, with newUser: User) {
        delete(user: user)
        
        var users = fetchUsers()
        users.append(newUser)
        Log.debug("Новый массив после редактирования: \(users)")
        save(users: users)
    }
    
    func delete(user: User) {
        var users = fetchUsers()
        if let index = users.firstIndex(where: { $0.name == user.name }) {
            Log.debug("Индекс для удаления: \(index)")
            users.remove(at: index)
            Log.debug("Массив после удаления: \(users)")
            save(users: users)
        } else {
            Log.error("Пользователь не найден для удаления")
        }
    }
    
    func findUser(withUsername userName: String) -> User? {
        let users = fetchUsers()
        if let user = users.filter({ $0.name == userName }).first {
            return user
        }
        return nil
    }
}
