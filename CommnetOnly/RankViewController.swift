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
    override func viewDidLoad() {
        super.viewDidLoad()
        rankTableView.delegate = self
        rankTableView.dataSource = self
    }


}

extension RankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IDENTIFIER_CELL_RANKTABLEVIEW, for: indexPath) as! RankTableViewCell
        
        return cell
    }
}
