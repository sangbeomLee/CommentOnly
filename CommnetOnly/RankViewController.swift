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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTableView.delegate = self
        rankTableView.dataSource = self
        networkManager.delegate = self
        
        networkManager.fetchPopularVideos()
    }


}

extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoBrain?.count ?? 0
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

extension RankViewController: NetworkManagerDelegate {
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
