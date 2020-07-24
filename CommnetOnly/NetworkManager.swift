//
//  NetworkMenager.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/23.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate {
    func didUpdateRankData(data: [VideoModel])
    func didUpdateImageData(data: Data?, index: Int)
    func didFailWithError(error: String)
}

struct NetworkManager {
    let baseUrl = "https://www.googleapis.com/youtube/v3"
    
    var delegate: NetworkManagerDelegate?
    
    func getImage(url: URL, index: Int) {
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.delegate?.didUpdateImageData(data: imageData, index: index)
            }
        }
    }

    func fetchPopularVideos() {
        let urlString = "\(baseUrl)/videos?regionCode=kr&chart=mostpopular&maxResults=10&part=snippet&key=\(APIKEY)"
        
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(error: "performRequest : wrong url")
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!.localizedDescription)
            }
            
            if let data = data {
                let rankDatas = self.parseRankJSON(with: data)
                
                DispatchQueue.main.async {
                    self.delegate?.didUpdateRankData(data: rankDatas)
                }
            }
        }
        
        task.resume()
    }
    
    func parseRankJSON(with rankData: Data) -> [VideoModel] {
        var rankModels = [VideoModel]()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RankDataModel.self, from: rankData)
            decodedData.items.forEach { item in
                let snippet = item.snippet
                let id = item.id
                let title = snippet.title
                let chnnelTitle = snippet.channelTitle
                let description = snippet.description
                let date = snippet.publishedAt
                let thumbnailUrl = snippet.thumbnails.thumbnail.url
                
                rankModels.append(VideoModel(id: id, title: title, channelTitle: chnnelTitle, description: description, date: date, thumbnailUrl: thumbnailUrl))
            }
        } catch {
            delegate?.didFailWithError(error: error.localizedDescription)
        }
        
        return rankModels
    }
}


