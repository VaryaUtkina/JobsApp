//
//  ViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 30.10.2024.
//

import UIKit

final class JobDetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var personButton: UIBarButtonItem!
    
    @IBOutlet var companyImage: UIImageView!
    @IBOutlet var companyView: UIView!
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var salaryLabel: UILabel!
    
    @IBOutlet var jobGeoLabel: UILabel!
    @IBOutlet var jobFunctionLabel: UILabel!
    @IBOutlet var jobTypeLabel: UILabel!
    
    @IBOutlet var jobDescription: UILabel!
    
    // MARK: - Public Properties
    var user: User!
    var job: Job!
    var theme: Theme! {
        didSet {
            updateCustomTheme(theme)
        }
    }
    weak var delegate: ThemeDelegate?
    weak var logoutDelegate: ProfileLogoutDelegate?
    weak var updateDelegate: UserUpdateDelegate?
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var topMenu = UIMenu()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopMenu()
        personButton.menu = topMenu
        
        setupUI()
        updateCustomTheme(theme)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateDelegate?.update(user: user)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfileFromDetails" {
            guard let profileVC = segue.destination as? ProfileViewController else { return }
            guard let user = sender as? User else { return }
            profileVC.user = user
            profileVC.theme = theme
            profileVC.delegate = delegate
            profileVC.updateDelegate = self
        }
    }
    
    // MARK: - IB Actions
    @IBAction func moonButtonAction(_ sender: UIBarButtonItem) {
        theme = super.changeTheme(theme, withDelegate: delegate)
    }
    
    // MARK: - Private Methods
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
}

// MARK: - Set up UI
private extension JobDetailsViewController {
    func setupUI() {
        setupView()
        navigationController?.navigationBar.tintColor = .labelGrey
        
        companyLabel.text = job.companyName
        
        positionLabel.text = job.jobTitle
        salaryLabel.text = job.salaryRange
        
        jobGeoLabel.text = job.emojiGeo
        jobTypeLabel.text = job.jobType.joined(separator: ", ")
        
        jobFunctionLabel.attributedText = applyStringFrom(htmlString: job.jobIndustry.joined(separator: ", "))
        jobDescription.attributedText = applyStringFrom(htmlString: job.jobDescription)
        
        setupHtmlLabels(jobDescription, jobFunctionLabel)

        networkManager.fetchData(from: job.companyLogo) { [unowned self] result in
            switch result {
            case .success(let imageData):
                companyImage.image = UIImage(data: imageData)
                companyImage.layer.cornerRadius = 20
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupView() {
        companyView.backgroundColor = .customView
        companyView.layer.cornerRadius = 20
        
        companyView.layer.shadowRadius = 8
        companyView.layer.shadowOpacity = 0.6
        companyView.layer.shadowColor = UIColor.black.cgColor
        companyView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func setupTopMenu() {
        let profile = UIAction(title: "Profile", image: UIImage(systemName: "person")) { [weak self] _ in
            guard let self else { return }
            performSegue(withIdentifier: "ShowProfileFromDetails", sender: user)
        }
        
        let logOut = UIAction(
            title: "Log Out",
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            attributes: .destructive
        ) { [weak self] _ in
            guard let self else { return }
            logoutDelegate?.logOut()
            dismiss(animated: true)
        }
        
        topMenu = UIMenu(title: "Options", children: [profile, logOut])
    }
    
    func setupHtmlLabels(_ labels: UILabel...) {
        labels.forEach { label in
            label.textColor = .mainLabel
            label.font = UIFont(name: DejaVuSans.origin.rawValue, size: 15)
        }
    }
    
    func applyStringFrom(htmlString: String) -> NSAttributedString {
        guard let data = htmlString.data(using: .utf8)  else { return NSAttributedString() }
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return attributedString
        } catch {
            Log.error("Ошибка при создании NSAttributedString из HTML: \(error)")
            return NSAttributedString()
        }
    }
}

// MARK: - UserUpdateDelegate
extension JobDetailsViewController: UserUpdateDelegate {
    func update(user: User) {
        self.user = user
    }
}

