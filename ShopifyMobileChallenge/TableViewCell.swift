//
//  TableViewCell.swift
//  ShopifyMobileChallenge
//
//  Created by Nick Kazan on 2019-01-08.
//  Copyright © 2019 Nick Kazan. All rights reserved.
//

import UIKit
//This class is for creating collection cells. It does so by changing the collection image and title
class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    func setCollection(collection: Collection){
        label.text = collection.title
        //Grab the resource photo from the url
        let url = URL(string: collection.image.src)
        let data = try? Data(contentsOf: url!)
        image1.image = UIImage(data: data!)
    }
}
