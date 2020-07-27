//
//  NetworkMenager.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/23.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

// 중복을 없애보자.

import Foundation

protocol NetworkManagerRankDelegate {
    func didUpdateRankData(data: [VideoModel])
    func didUpdateImageData(data: Data?, index: Int)
    func didFailWithError(error: String)
}

protocol NetworkManagerCommentDelegate {
    func didFailWithError(error: String)
    func didUpdateCommentData(data: [CommentModel])
    func didUpdateImageData(data: Data?, index: Int)
}

struct NetworkManager {
    let baseUrl = "https://www.googleapis.com/youtube/v3"
    
    var rankDelegate: NetworkManagerRankDelegate?
    var commentDelegate: NetworkManagerCommentDelegate?
    
    func getImage(url: URL, index: Int) {
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.rankDelegate?.didUpdateImageData(data: imageData, index: index)
            }
        }
    }
    func getCommentImage(url: URL, index: Int) {
        DispatchQueue.global().async {
            let imageData = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self.commentDelegate?.didUpdateImageData(data: imageData, index: index)
            }
        }
    }

    func fetchPopularVideos() {
        let urlString = "\(baseUrl)/videos?regionCode=kr&chart=mostpopular&maxResults=10&part=snippet&key=\(APIKEY)"
        
        performRankRequest(with: urlString)
    }
    
    func fetchVideoComments(id videoId: String, order: String) {
        let urlString = "\(baseUrl)/commentThreads?part=snippet&videoId=\(videoId)&maxResults=100&order=\(order)&key=\(APIKEY)"
        
        performCommentRequest(with: urlString)
    }

    
    func performRankRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            rankDelegate?.didFailWithError(error: "performRankRequest : wrong url")
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.rankDelegate?.didFailWithError(error: error!.localizedDescription)
            }
            
            if let data = data {
                let rankDatas = self.parseRankJSON(with: data)
                
                DispatchQueue.main.async {
                    self.rankDelegate?.didUpdateRankData(data: rankDatas)
                }
            }
        }
        
        task.resume()
    }
    
    func performCommentRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            commentDelegate?.didFailWithError(error: "performCommentRequest : wrong url")
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.commentDelegate?.didFailWithError(error: error!.localizedDescription)
            }
            
            if let data = data {
                let commentData = self.parseCommentJSON(with: data)
                
                DispatchQueue.main.async {
                    self.commentDelegate?.didUpdateCommentData(data: commentData)
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
            rankDelegate?.didFailWithError(error: error.localizedDescription)
        }
        
        return rankModels
    }
    
    func parseCommentJSON(with commentData: Data) -> [CommentModel] {
        var commentModels = [CommentModel]()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CommentDataModel.self, from: commentData)
            decodedData.items.forEach { item in
                let snippet = item.snippet
                let topLevelComment = snippet.topLevelComment
                let comment = topLevelComment.comment

                let id = topLevelComment.id
                let text = comment.textDisplay
                let name = comment.authorDisplayName
                let date = comment.publishedAt
                let likeCount = comment.likeCount
                let thumbnailUrl = comment.authorProfileImageUrl

                commentModels.append(CommentModel(id: id, text: text, name: name, date: date, likeCount: likeCount, thumbnailUrl: thumbnailUrl))
            }
        } catch {
            commentDelegate?.didFailWithError(error: error.localizedDescription)
        }

        return commentModels
    }
}


