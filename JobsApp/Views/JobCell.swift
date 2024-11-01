//
//  JobCell.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import UIKit

final class JobCell: UICollectionViewCell {
    
    @IBOutlet var companyImage: UIImageView!
    
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var annualSalaryLabel: UILabel!
    @IBOutlet var rangeSalaryLabel: UILabel!
    @IBOutlet var remoteLabel: UILabel!
    @IBOutlet var jobGeoLabel: UILabel!
    @IBOutlet var jobExpertLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func configure(with job: Job) {
        jobTitleLabel.text = job.jobTitle
        companyName.text = job.companyName
        jobExpertLabel.text = job.jobExcerpt
        rangeSalaryLabel.text = job.salaryRange
        
        
        jobGeoLabel.text = "\(flagEmoji(forCountryCode: job.jobGeo)) \(job.jobGeo)"
        if let currency = job.salaryCurrency {
            annualSalaryLabel.text = "Annual salary, \(currency):"
        }
        
        customize(
            font: UIFont(name: DejaVuSans.bold.rawValue, size: 19)
            ?? UIFont.systemFont(ofSize: 19),
            forLabels: jobTitleLabel
        )
        customize(
            font: UIFont(name: DejaVuSans.bold.rawValue, size: 15)
            ?? UIFont.systemFont(ofSize: 19),
            forLabels: companyName, rangeSalaryLabel, jobGeoLabel
        )
        customize(
            font: UIFont(name: DejaVuSans.origin.rawValue, size: 15)
            ?? UIFont.systemFont(ofSize: 15),
            forLabels: annualSalaryLabel, remoteLabel
        )
        customize(
            font: UIFont(name: DejaVuSans.origin.rawValue, size: 14)
            ?? UIFont.systemFont(ofSize: 13),
            forLabels: jobExpertLabel
        )
        
        networkManager.fetchData(from: job.companyLogo) { [unowned self] result in
            switch result {
            case .success(let imageData):
                companyImage.image = UIImage(data: imageData)
                companyImage.layer.cornerRadius = 8
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func customize(font: UIFont, forLabels labels: UILabel...) {
        labels.forEach { label in
            label.font = font
        }
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 20
        layer.masksToBounds = false
        
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func flagEmoji(forCountryCode countryCode: String) -> Character {
        if countryCode == "Anywhere" {
            return "🌐"
        }
        
        var flagString = ""
        for scalar in countryCode.unicodeScalars {
            guard let regionScalar = UnicodeScalar(127397 + scalar.value) else {
                return " "
            }
            flagString.unicodeScalars.append(regionScalar)
        }
        return flagString.first ?? " "
    }
}
