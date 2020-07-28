//
//  NetworkMenager.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/23.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

// 중복을 없애보자.
// 검색 부분을 만들어야 하는데 그럼 3개가 된다..홀랭...
// 제네릭으로 만들면 되지 않을까?

import Foundation

protocol NetworkManagerDelegate {
    func didFailWithError(error: String)
}

struct NetworkManager {
    let baseUrl = "https://www.googleapis.com/youtube/v3"
    
    var delegate: NetworkManagerDelegate?
    
    func getImage(url: URL, index: Int, complition: @escaping (Data?) -> ()) {
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                complition(imageData)
            }
        }
    }

    func getRankVideos(complition: @escaping ([VideoModel]) -> ()) {
        let urlString = "\(baseUrl)/videos?regionCode=kr&chart=mostpopular&maxResults=10&part=snippet&key=\(APIKEY)"
        fetchDatas(with: urlString, type: "Rank") { (videos: [VideoModel]?) in
            guard let videoModels = videos else{
                self.delegate?.didFailWithError(error: "fetchData : Fail")
                return
            }
            complition(videoModels)
        }
    }
    
    func getComments(id videoId: String, order: String, complition: @escaping ([CommentModel]) -> ()) {
        let urlString = "\(baseUrl)/commentThreads?part=snippet&videoId=\(videoId)&maxResults=100&order=\(order)&key=\(APIKEY)"
        fetchDatas(with: urlString, type: "Comment") { (comments: [CommentModel]?) in
            guard let commentModels = comments else{
                self.delegate?.didFailWithError(error: "fetchData : Fail")
                return
            }
            complition(commentModels)
        }
    }

    func fetchDatas<T>(with urlString: String, type: String, complition: @escaping (T?) -> ()) {
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(error: "performRequest : wrong url")
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!.localizedDescription)
            }
            
            if let data = data {
                if type == "Rank" {
                    var datas = [VideoModel]()
                    self.parseJSON(with: data) { (rank: RankDataModel) in
                        rank.items.forEach { item in
                            let snippet = item.snippet
                            let id = item.id
                            let title = snippet.title
                            let chnnelTitle = snippet.channelTitle
                            let description = snippet.description
                            let date = snippet.publishedAt
                            let thumbnailUrl = snippet.thumbnails.thumbnail.url
                            
                            datas.append(VideoModel(id: id, title: title, channelTitle: chnnelTitle, description: description, date: date, thumbnailUrl: thumbnailUrl))
                        }
                        complition(datas as? T)
                    }
                }
                
                if type == "Comment" {
                    var datas = [CommentModel]()
                    self.parseJSON(with: data) { (comment: CommentDataModel) in
                        comment.items.forEach { item in
                            let snippet = item.snippet
                            let topLevelComment = snippet.topLevelComment
                            let comment = topLevelComment.comment

                            let id = topLevelComment.id
                            let text = comment.textDisplay
                            let name = comment.authorDisplayName
                            let date = comment.publishedAt
                            let likeCount = comment.likeCount
                            let thumbnailUrl = comment.authorProfileImageUrl

                            datas.append(CommentModel(id: id, text: text, name: name, date: date, likeCount: likeCount, thumbnailUrl: thumbnailUrl))
                        }
                        complition(datas as? T)
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    func parseJSON<T: Codable>(with data: Data, complition: @escaping (T) -> ()) {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            complition(decodedData)
        } catch {
            delegate?.didFailWithError(error: error.localizedDescription)
        }
    }
}


