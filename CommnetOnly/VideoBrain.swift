//
//  RankBrain.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/24.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

class VideoBrain {
    private var videos: [VideoModel]
    
    var count: Int {
        return videos.count
    }
    
    init(videos: [VideoModel]) {
        self.videos = videos
    }
    
    func setImage(imageData: Data?, index: Int) {
        videos[index].imageData = imageData
    }
    
    func getVideo(index: Int) -> VideoModel {
        return videos[index]
    }
    
    func getThumbnail(with networkManager: NetworkManager) {
        videos.enumerated().forEach {
            networkManager.getImage(url: $0.element.thumbnailUrl, index: $0.offset)
        }
    }
}
