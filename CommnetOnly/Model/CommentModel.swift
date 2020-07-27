//
//  CommentModel.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/27.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

struct CommentModel {
    var id: String
    var text: String
    var name: String
    var date: String
    var likeCount: Int
    var thumbnailUrl: URL
    var imageData: Data?
}
