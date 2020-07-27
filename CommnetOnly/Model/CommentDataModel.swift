//
//  CommentDataModel.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/27.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import Foundation

struct CommentDataModel: Codable {
    struct Comment: Codable {
        var textDisplay: String
        var authorDisplayName: String
        var authorProfileImageUrl: URL
        var likeCount: Int
        var publishedAt: String
    }

    struct TopLevelComment: Codable {
        var id: String
        var comment: Comment

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case comment = "snippet"
        }
    }

    struct Snippet: Codable {
        var topLevelComment: TopLevelComment
    }

    struct Items: Codable {
        var snippet: Snippet
    }
    var nextPageToken: String
    var items: [Items]
}
