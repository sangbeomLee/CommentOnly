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
    
    func getVideo(index: Int) -> VideoModel {
        return videos[index]
    }
}
