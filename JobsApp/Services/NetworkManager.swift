//
//  NetworkManager.swift
//  JobsApp
//
//  Created by Варвара Уткина on 31.10.2024.
//

import Foundation
import Alamofire

enum Link {
    case jobsUrl
    case postRequest
    
    var url: URL {
        switch self {
        case .jobsUrl:
            URL(string: "https://jobicy.com/api/v2/remote-jobs?count=20&geo=usa&industry=marketing&tag=seo")!
        case .postRequest:
            URL(string: "")!
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchJobs(from url: URL, completion: @escaping(Result<JobList, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: JobList.self) { dataResponse in
                switch dataResponse.result {
                case .success(let jobList):
                    completion(.success(jobList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchData(from url: URL, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { responseData in
                switch responseData.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
    }
}
