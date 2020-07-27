import Foundation

struct RankDataModel: Codable {
    struct Thumbnail: Codable {
        var url: URL
    }

    struct Thumbnails: Codable {
        
        var thumbnail: Thumbnail
        
        enum CodingKeys: String, CodingKey {
            case thumbnail = "medium"
        }
    }

    struct Snippet: Codable {
        var publishedAt: String
        var title: String
        var description: String
        var channelTitle: String
        var thumbnails: Thumbnails
    }

    struct Items: Codable {
        var id: String
        var snippet: Snippet
    }

    var items: [Items]
}
