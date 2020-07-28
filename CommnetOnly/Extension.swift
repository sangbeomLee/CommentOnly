//
//  Extension.swift
//  CommnetOnly
//
//  Created by 이상범 on 2020/07/28.
//  Copyright © 2020 sangbeomLee. All rights reserved.
//

import UIKit

extension UIImageView {
    func getImageFromUrl(url: URL, complition: @escaping (Data?) -> ()){
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                print("no Image")
                return
            }
            complition(imageData)
        }
    }
}
