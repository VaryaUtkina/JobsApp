//
//  ViewController.swift
//  JobsApp
//
//  Created by Варвара Уткина on 30.10.2024.
//

import UIKit

final class JobDetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
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
    var job: Job!
    var theme: Theme! {
        didSet {
            updateCustomTheme(theme)
        }
    }
    weak var delegate: JobDetailsViewControllerDelegate?
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCustomTheme(theme)
    }
    @IBAction func moonButtonAction(_ sender: UIBarButtonItem) {
        theme = (theme == .light) ? .dark : .light
        
        storageManager.save(theme: theme)
        delegate?.reloadTheme(theme)
    }
    
    private func updateCustomTheme(_ theme: Theme) {
        super.updateTheme(theme)
        navigationItem.rightBarButtonItem?.image = theme == .light
        ? UIImage(systemName: "moon")
        : UIImage(systemName: "moon.fill")
    }
}

// MARK: - Set up UI
extension JobDetailsViewController {
    private func setupUI() {
        setupView()
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
    
    private func setupView() {
        companyView.backgroundColor = .customView
        companyView.layer.cornerRadius = 20
        
        companyView.layer.shadowRadius = 8
        companyView.layer.shadowOpacity = 0.6
        companyView.layer.shadowColor = UIColor.black.cgColor
        companyView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func setupHtmlLabels(_ labels: UILabel...) {
        labels.forEach { label in
            label.textColor = .mainLabel
            label.font = UIFont(name: DejaVuSans.origin.rawValue, size: 15)
        }
    }
    
    private func applyStringFrom(htmlString: String) -> NSAttributedString {
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

