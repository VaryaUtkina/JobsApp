//
//  Extention + UIViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 28.11.2024.
//

import UIKit

extension UIViewController {
    func updateTheme(_ theme: Theme) {
        overrideUserInterfaceStyle = theme.style
        navigationController?.overrideUserInterfaceStyle = theme.style
    }
}
