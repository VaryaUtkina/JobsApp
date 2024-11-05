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
    
    private init() {}
    
    func fetchTheme() -> Theme {
        guard let data = userDefaults.data(forKey: themeKey) else { return .light }
        guard let theme = try? JSONDecoder().decode(Theme.self, from: data) else { return .light }
        return theme
    }
    
    func save(theme: Theme) {
        guard let data = try? JSONEncoder().encode(theme) else { return }
        userDefaults.set(data, forKey: themeKey)
    }
}
