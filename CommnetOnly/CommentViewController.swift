//
//  CommentViewController.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/24.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTableView.delegate = self
        commentTableView.dataSource = self
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
        return 100
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.titleLabel.text = "\(indexPath.row)"
        
        return cell
    }
    
    
}
