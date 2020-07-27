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
        networkManager?.commentDelegate = self
        if let id = commentBrain?.video.id {
            networkManager?.fetchVideoComments(id: id, order: "relevance")
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
            self.commentTableViewHeight.constant = self.commentTableView.contentSize.height
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
            cell.configure(comment: comment)
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

extension CommentViewController: NetworkManagerCommentDelegate {
    func didUpdateImageData(data: Data?, index: Int) {
        commentBrain?.setImage(imageData: data, index: index)
        self.resizeTableView()
        self.commentTableView.reloadData()
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
    func didUpdateCommentData(data: [CommentModel]) {
        commentBrain?.getComments(comments: data)
        commentBrain?.getThumbnail(with: networkManager!)
    }
    
    
}
