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
    var theme: Theme!
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
//    private func getJobDescription() {
//        let htmlString = """
//            <p>The Product Marketing team is part of our high-growth Marketing organization which is focused on driving the overall growth strategy through content, launches, sales enablement and strategic GTM activities. We ensure our programs and activities consistently drive activation, engagement, and retention through collaboration with teams like Product Management, Growth, Demand Generation and Sales.</p>\n<p>We are looking for an experienced and skilled product marketer who will be a key member of the Product Marketing team. In this role, you will be responsible for shaping messaging for the data practitioner audience, driving product and feature launches, competitive intel and GTM content strategy across our products.</p>\n<p>Your work will ensure that prospects and customers know that Airflow is crucial to their data ecosystem, why Astro is the modern platform for DataOps and the best place to run Airflow, and how to get started.</p>\n<p>This role will be based in the US (NYC preferable), with the option to be fully remote or work in one of our offices.</p>\n<h2><strong>What you get to do:</strong></h2>\n<ul>\n<li>Messaging and Positioning: Develop compelling messaging, articulate product differentiation and our unique positioning in the market</li>\n<li>Launches: Partner closely with Product Management in defining feature releases. Plan and execute end to end launches of these features to market alongside Demand Generation and Sales.</li>\n<li>Content: Work closely with teams such as Developer Relations, Product Management, Demand Generation, Web, SEO, Sales and Partner Marketing to identify gaps and develop high-quality technical content.</li>\n<li>Field Enablement: Create product and technical enablement content to help field sales teams prospect, generate pipeline, and educate buyers about our differentiation</li>\n<li>Event support: Drive messaging and content for events. Represent the respective product area at field events and meetups.</li>\n<li>Competitive Intelligence: Analyze the industry, synthesize key market trends, research relevant competitors and create succinct sales consumable battlecards</li>\n</ul>\n<h2><strong>What you bring to the role:</strong></h2>\n<ul>\n<li><strong>5+ years of relevant work experience (product marketing or product management in the data infrastructure, database management, data engineering or similar space)</strong></li>\n<li>BA/BS degree preferred, but relevant experience will be equally considered</li>\n<li>Ideally, experience with or understanding of workflow management, pipeline development, ETL and/or SDLC.</li>\n<li>The ability to clearly articulate the value of a product or service to technical customers</li>\n<li>Experience leading product or feature launches and contributing to larger launches with a team</li>\n<li>A collaborative spirit, sense of ownership, and willingness to learn</li>\n</ul>\n<h2>Bonus points if you have:</h2>\n<ul>\n<li>Familiarity with or knowledge of Airflow and/or similar data products</li>\n<li>Familiarity with Data Engineering, ETL, Observability, DBMS or Data Warehousing products</li>\n<li>Experience with commercializing open-source offerings</li>\n<li>Experience with a developer-focused product</li>\n<li>Experience with or knowledge of cloud computing, CI/CD and modern data engineering best practices</li>\n<li>MBA or Masters in Computer Science, Data Science, Product Management or other Graduate degree</li>\n</ul>\n<p><em>The estimated salary for this role ranges from $125,000 &#8211; $150,000, along with an equity component. This range is merely an estimate, and the width of the range reflects willingness to consider candidates with broad prior seniority. Actual compensation may deviate from this range based on skills, experience, and qualifications</em></p>
//        """
//        if let data = htmlString.data(using: .utf8) {
//            do {
//                let attributedString = try NSAttributedString(
//                    data: data,
//                    options: [
//                        .documentType: NSAttributedString.DocumentType.html,
//                        .characterEncoding: String.Encoding.utf8.rawValue
//                    ],
//                    documentAttributes: nil
//                )
//                label.attributedText = attributedString
//                label.textColor = .white
//            } catch {
//                label.text = ""
//            }
//        }
//    }
    
    private func setupUI() {
        networkManager.fetchData(from: job.companyLogo) { [unowned self] result in
            switch result {
            case .success(let imageData):
                companyImage.image = UIImage(data: imageData)
                companyImage.layer.cornerRadius = 20
            case .failure(let error):
                print(error)
            }
        }
        
        companyLabel.text = job.companyName
    }
}

