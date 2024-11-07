//
//  Job.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import Foundation

struct JobList: Decodable {
    let jobs: [Job]
}

struct Job: Decodable {
    let jobTitle: String
    let companyName: String
    let companyLogo: URL
    let jobIndustry: [String]
    let jobType: [String]
    let jobGeo: String
    let jobExcerpt: String
    let jobDescription: String
    let pubDate: String
    let annualSalaryMin: String?
    let annualSalaryMax: String?
    let salaryCurrency: String?
    
    var salaryRange: String {
        if let annualSalaryMin, let annualSalaryMax {
            return "\(formatNumberString(annualSalaryMin)) - \(formatNumberString(annualSalaryMax))"
        }
        return "not specified"
    }
    
    var emojiGeo: String {
        "\(flagEmoji(forCountryCode: jobGeo)) \(jobGeo)"
    }
    
    private func formatNumberString(_ numberString: String) -> String {
        guard let salary = Int(numberString) else {
            return numberString
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: salary)) ?? numberString
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
