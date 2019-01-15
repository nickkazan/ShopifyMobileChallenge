//
//  TableViewCellDetailed.swift
//  ShopifyMobileChallenge
//
//  Created by Nick Kazan on 2019-01-10.
//  Copyright © 2019 Nick Kazan. All rights reserved.
//

import UIKit
//This class is for creating product cells. It does so by changing the inventory, image, and title.
class TableViewCellDetailed: UITableViewCell {
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var inventoryLabel: UILabel!
    
    func setProductDetailed(product: Product, imageURL: String, inventory: Int) {
        label2.text = product.title
        inventoryLabel.text = "Inventory Count: " + String(inventory)
        //Grab the resource photo from the url
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        image2.image = UIImage(data: data!)
    }
}
