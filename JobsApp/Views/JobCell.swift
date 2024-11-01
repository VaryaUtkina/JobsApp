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
    @IBOutlet var annualSalaryLabel: UILabel!
    @IBOutlet var rangeSalaryLabel: UILabel!
    @IBOutlet var jobGeoLabel: UILabel!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var jobExpertLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
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
    
    func configure(with job: Job) {
        jobTitleLabel.text = job.jobTitle
        jobGeoLabel.text = job.jobGeo
        companyName.text = job.companyName
        jobExpertLabel.text = job.jobExcerpt
        rangeSalaryLabel.text = job.salaryRange
        
        if let currency = job.salaryCurrency {
            annualSalaryLabel.text = "Annual salary, \(currency):"
        }
        
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
}
