//
//  CommentBrain.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/27.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

class CommentBrain {
    var video: VideoModel
    var comments: [CommentModel]?
    
    init(video: VideoModel) {
        self.video = video
    }
    
    func getComments(comments: [CommentModel]) {
        self.comments = comments
    }

    func setImage(imageData: Data?, index: Int) {
        comments?[index].imageData = imageData
    }
    
    func sortLikeCount() {
        comments?.sort{ $0.likeCount > $1.likeCount }
    }
}
