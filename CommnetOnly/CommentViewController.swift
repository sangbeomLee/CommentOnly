//
//  CommentViewController.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/24.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    
    var commentBrain: CommentBrain?
    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        if let id = commentBrain?.video.id {
            networkManager?.getComments(id: id, order: "relevance", complition: { comments in
                self.commentBrain?.getComments(comments: comments)
                self.commentBrain?.sortLikeCount()
                self.resizeTableView()
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = commentBrain?.video.title
        if let imageData = commentBrain?.video.imageData {
            thumbnailImageView.image = UIImage(data: imageData)
        }
        resizeTableView()
    }
    
    func resizeTableView() {
        DispatchQueue.main.async {
            self.commentTableView.layoutIfNeeded()
            self.commentTableView.reloadData()
            
            // 왜 contentSize.height 이 절반정도 뿐이 안나오는가?
            self.commentTableViewHeight.constant = self.commentTableView.contentSize.height * 2
        }
    }

}

//MARK: - UITableView
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = commentBrain?.comments?.count ?? 0
        return count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        if let comment = commentBrain?.comments?[indexPath.row] {
            if comment.imageData == nil {
                networkManager?.getImage(url: comment.thumbnailUrl, index: indexPath.row, complition: {
                    self.commentBrain?.comments?[indexPath.row].imageData = $0
                    tableView.reloadData()
                })
            }
            cell.configure(comment: comment)
            cell.dateLabel.text = "\(indexPath.row)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

