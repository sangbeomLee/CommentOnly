//
//  NetworkMenager.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/23.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

struct NetworkManager {
    let baseUrl = "https://www.googleapis.com/youtube/v3"

    func fetchPopularVideos() {
        let urlString = "\(baseUrl)/videos?chart=mostpopular&maxResults=10&key=\(APIKEY)"
        
    }

}
