//
//  ViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 30.10.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }


    private func fetchData() {
        URLSession.shared.dataTask(with: URL(string: "https://jobicy.com/api/v2/remote-jobs?count=20&geo=usa&industry=marketing&tag=seo")!) { data, response, error in
            guard let response else {
                print("No response")
                return
            }
            print(response)
        }.resume()
    }
}

