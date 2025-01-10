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

protocol JobDetailsViewControllerDelegate: AnyObject {
    func reloadTheme(_ theme: Theme)
}

final class JobsViewController: UICollectionViewController {
    
    @IBOutlet var personButton: UIBarButtonItem!
    
    var user: User!
    var theme: Theme! {
        didSet {
            updateCustomTheme(theme)
        }
    }
    weak var delegate: JobsViewControllerDelegate?
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private var jobs: [Job] = []
    private var topMenu = UIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopMenu()
        personButton.menu = topMenu
        
        updateCustomTheme(theme)
        fetchJobs()
        
        navigationController?.navigationBar.tintColor = .mainLabel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showProfile" {
//            guard let profileVC = segue.destination as? ProfileViewController else { return }
//            Log.debug("ProfileVC was opened") // helper, delete that
//        }
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            guard let jobDetailsVC = segue.destination as? JobDetailsViewController else { return }
            jobDetailsVC.theme = theme
            jobDetailsVC.job = jobs[indexPath.row]
            jobDetailsVC.delegate = self
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

    @IBAction func moonButtonAction(_ sender: UIBarButtonItem) {
        theme = (theme == .light) ? .dark : .light
        
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
    
    private func updateCustomTheme(_ theme: Theme) {
        super.updateTheme(theme)
        guard let buttonItems = navigationItem.rightBarButtonItems else {
            Log.error("No button item")
            return
        }
        for button in buttonItems {
            if button.tag == 0 {
                button.image = theme == .light
                ? UIImage(systemName: "moon")
                : UIImage(systemName: "moon.fill")
            }
        }
    }
    
    private func setupTopMenu() {
        let profile = UIAction(title: "Profile", image: UIImage(systemName: "person")) { [weak self] _ in
            guard let self else { return }
            performSegue(withIdentifier: "showProfile", sender: user)
        }
        
        let logOut = UIAction(
            title: "Log Out",
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            attributes: .destructive
        ) { [weak self] _ in
            guard let self else { return }
//            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            delegate?.logOut()
            dismiss(animated: true)
        }
        
        topMenu = UIMenu(title: "Options", children: [profile, logOut])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension JobsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width - 32
        let job = jobs[indexPath.item]
        
        let label = UILabel()
        label.font = UIFont(name: DejaVuSans.bold.rawValue, size: 19)
        label.numberOfLines = 0
        label.text = job.jobTitle
        
        let maxSize = CGSize(width: width - 40, height: CGFloat.greatestFiniteMagnitude)
        let textHeight = label.sizeThatFits(maxSize).height
        let lineHeight = UIFont(name: DejaVuSans.bold.rawValue, size: 19)?.lineHeight ?? 22

        let numberOfLines = Int(textHeight/lineHeight)
        let height: CGFloat = numberOfLines <= 1 ? 180 : 200
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - JobDetailsViewControllerDelegate
extension JobsViewController: JobDetailsViewControllerDelegate {
    func reloadTheme(_ theme: Theme) {
        self.theme = theme
        updateCustomTheme(theme)
    }
}
