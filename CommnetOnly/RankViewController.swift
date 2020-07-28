//
//  RankViewController.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/22.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet weak var rankTableView: UITableView!
    
    var networkManager = NetworkManager()
    var videoBrain: VideoBrain? {
        didSet {
            DispatchQueue.main.async {
                self.rankTableView.reloadData()
            }
        }
    }
    let searchVC = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTableView.delegate = self
        rankTableView.dataSource = self
        
        // searchResult
        searchVC.searchBar.delegate = self
        self.navigationItem.titleView = searchVC.searchBar
        searchVC.searchBar.placeholder = "유튜브 영상을 입력하세요"
        searchVC.hidesNavigationBarDuringPresentation = false
        
        networkManager.getRankVideos { videos in
            self.videoBrain = VideoBrain(videos: videos)
        }
    }

}

//MARK: - UISearchResult
extension RankViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        print("cancle")
    }
}

//MARK: - UITableView
extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoBrain?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let commentVC = storyboard?.instantiateViewController(identifier: "CommentViewController") as? CommentViewController else {
            print("no CommentVC")
            return
        }
        if let video = videoBrain?.getVideo(index: indexPath.row) {
            commentVC.commentBrain = CommentBrain(video: video)
            commentVC.networkManager = networkManager
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIER_CELL_RANKTABLEVIEW, for: indexPath) as! RankTableViewCell
            
        if let video = videoBrain?.getVideo(index: indexPath.row) {
            if video.imageData == nil {
                networkManager.getImage(url: video.thumbnailUrl, index: indexPath.row) {
                    self.videoBrain?.videos?[indexPath.row].imageData = $0
                    tableView.reloadData()
                }
            }
            cell.configure(with: video)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
