//
//  ApiService.swift
//  MyYouTube
//
//  Created by Elf on 23.07.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import Foundation

class ApiService {
    static let sharedInstance = ApiService()
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"

    func fetchHomeVideos(completion: @escaping (([Video]) -> ())) {
        fetchVideos(apiUrl: "\(baseUrl)/home.json", completion: completion)
    }

    func fetchTrendingVideos(completion: @escaping (([Video]) -> ())) {
        fetchVideos(apiUrl: "\(baseUrl)/trending.json", completion: completion)
    }

    func fetchSubscriptionsVideos(completion: @escaping (([Video]) -> ())) {
        fetchVideos(apiUrl: "\(baseUrl)/subscriptions.json", completion: completion)
    }

    func fetchAccountVideos(completion: @escaping (([Video]) -> ())) {
        fetchVideos(apiUrl: "\(baseUrl)/accounts.json", completion: completion)
    }

    func fetchVideos(apiUrl: String, completion: @escaping ([Video]) -> ()) {
        let url = NSURL(string: apiUrl)
        let request = URLRequest(url: url! as URL)
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            do {
                guard let respData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as? [[String: AnyObject]] else {
                    completion([])
                    return
                }

                DispatchQueue.main.async {
                    completion(jsonDictionaries.map({ return Video($0) }))
                }
            } catch let jsonErr {
                print(jsonErr)
                completion([])
            }
        }.resume()
    }
}
