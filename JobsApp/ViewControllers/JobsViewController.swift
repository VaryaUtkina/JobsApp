//
//  JobsViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
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

final class JobsViewController: UICollectionViewController {

    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private var jobs: [Job] = []
    private var theme = Theme.light
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = storageManager.fetchTheme()
        updateTheme(theme)
        fetchJobs()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            guard let jobDetailsVC = segue.destination as? JobDetailsViewController else { return }
            jobDetailsVC.theme = theme
            jobDetailsVC.job = jobs[indexPath.row]
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        jobs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobCell", for: indexPath)
        guard let cell = cell as? JobCell else { return UICollectionViewCell() }
        let job = jobs[indexPath.item]
        cell.configure(with: job)
        return cell
    }

    // MARK: UICollectionViewDelegate

    @IBAction func moonButtonAction(_ sender: UIBarButtonItem) {
        if theme == .light {
            theme = .dark
        } else {
            theme = .light
        }
        updateTheme(theme)
        storageManager.save(theme: theme)
    }
    
    private func fetchJobs() {
        networkManager.fetchJobs(from: Link.jobsUrl.url) { [unowned self] result in
            switch result {
            case .success(let jobList):
                jobs = jobList.jobs
                collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateTheme(_ theme: Theme) {
        overrideUserInterfaceStyle = theme.style
        navigationController?.overrideUserInterfaceStyle = theme.style
        navigationItem.rightBarButtonItem?.image = theme == .light
        ? UIImage(systemName: "moon")
        : UIImage(systemName: "moon.fill")
    }
}

extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width - 32, height: 180)
    }
}
