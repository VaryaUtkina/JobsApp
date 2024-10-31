//
//  NetworkManager.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func fetchJobs() {
        URLSession.shared.dataTask(with: URL(string: "https://jobicy.com/api/v2/remote-jobs?count=20&geo=usa&industry=marketing&tag=seo")!) { data, response, error in
            guard let response else {
                print("No response")
                return
            }
            print(response)
        }.resume()
    }
}
