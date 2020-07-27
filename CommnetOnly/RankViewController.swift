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
    var videoBrain: VideoBrain?
    let searchVC = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTableView.delegate = self
        rankTableView.dataSource = self
        networkManager.rankDelegate = self
        
        // searchResult
        searchVC.searchBar.delegate = self
        self.navigationItem.titleView = searchVC.searchBar
        searchVC.searchBar.placeholder = "유튜브 영상을 입력하세요"
        searchVC.hidesNavigationBarDuringPresentation = false
        
        networkManager.fetchPopularVideos()
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
            
        if let videoBrain = videoBrain {
            cell.configure(with: videoBrain.getVideo(index: indexPath.row))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

//MARK: - NetworkManager
extension RankViewController: NetworkManagerRankDelegate {
    func didUpdateImageData(data: Data?, index: Int) {
        videoBrain?.setImage(imageData: data, index: index)
        rankTableView.reloadData()
    }
    
    func didUpdateRankData(data: [VideoModel]) {
        videoBrain = VideoBrain(videos: data)
        videoBrain?.getThumbnail(with: networkManager)
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
    
}
