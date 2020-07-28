//
//  CommentTableViewCell.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/24.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.width/2
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(comment: CommentModel) {
        commentLabel.text = comment.text
        dateLabel.text = comment.date
        likeCountLabel.text = "\(comment.likeCount)"
        nameLabel.text = comment.name
        if let data = comment.imageData {
            thumbnailImageView.image = UIImage(data: data)
        }
        
    }

}
