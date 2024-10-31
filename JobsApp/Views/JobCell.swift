//
//  JobCell.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import UIKit

final class JobCell: UICollectionViewCell {
    
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var annualSalaryLabel: UILabel!
    @IBOutlet var jobGeoLabel: UILabel!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var jobExpertLabel: UILabel!

    override func awakeFromNib() {
          super.awakeFromNib()
              
          contentView.layer.cornerRadius = 20
          contentView.layer.masksToBounds = true
          
          layer.cornerRadius = 20
          layer.masksToBounds = false
          
          layer.shadowRadius = 8.0
          layer.shadowOpacity = 0.6
          layer.shadowColor = UIColor.black.cgColor
          layer.shadowOffset = CGSize(width: 0, height: 5)
      }
}
