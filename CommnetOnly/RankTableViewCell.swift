//
//  RankTableViewCell.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/22.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with video: VideoModel) {
        channelTitleLabel.text = video.channelTitle
        titleLabel.text = video.title
        subtitleLabel.text = video.description
        if let imageData = video.imageData {
            thumbnailImageView.image = UIImage(data: imageData)
        }
    }

}
