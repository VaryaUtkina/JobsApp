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
    let annualSalaryMin: Int?
    let annualSalaryMax: Int?
    let salaryCurrency: String?
    
    var salaryRange: String {
        if let annualSalaryMin, let annualSalaryMax {
            return "\(formatNumber(annualSalaryMin)) - \(formatNumber(annualSalaryMax))"
        }
        return "not specified"
    }
    
    var emojiGeo: String {
        "\(flagEmoji(forCountryCode: jobGeo)) \(jobGeo)"
    }
    
    private func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return numberFormatter.string(from: NSNumber(value: number)) ?? number.formatted()
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
