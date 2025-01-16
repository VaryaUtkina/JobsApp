//
//  Theme.swift
//  JobsApp
//
//  Created by Варвара Уткина on 16.01.2025.
//

import UIKit

enum Theme: Codable {
    case light
    case dark
    
    var style: UIUserInterfaceStyle {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }
}
