//
//  JobsViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import UIKit

final class JobsViewController: UICollectionViewController {

    private let networkManager = NetworkManager.shared
    private var jobs: [Job] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        navigationController?.overrideUserInterfaceStyle = .light
        fetchJobs()
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
        if overrideUserInterfaceStyle == .light {
            navigationController?.overrideUserInterfaceStyle = .dark
            overrideUserInterfaceStyle = .dark
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "moon.fill")
        } else {
            navigationController?.overrideUserInterfaceStyle = .light
            overrideUserInterfaceStyle = .light
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "moon")
        }
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
