//
//  SecondViewController.swift
//  ShopifyMobileChallenge
//
//  Created by Nick Kazan on 2019-01-10.
//  Copyright © 2019 Nick Kazan. All rights reserved.
//

import UIKit

//All of the following structs are used to hold the data from the api.
struct Products: Decodable {
    let products: [Product]
}
struct Product: Decodable {
    let id: Int
    let title: String
    let variants: [Variant]
    struct Variant: Decodable {
        let inventory_quantity: Int
    }
}
//Relates to the second view controller
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableList: UITableView!
    var productIds = [Int]()
    var collectionImage = String()
    var productsArray = [Product]()
    var collectionTitle = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //grabs the prototype cell with the identifier 'cell2'
        let cell = tableList.dequeueReusableCell(withIdentifier: "cell2") as! TableViewCellDetailed
        let totalInventory = addVariants(currentProduct: productsArray[indexPath.row])
        cell.setProductDetailed(product: productsArray[indexPath.row], imageURL: collectionImage, inventory: totalInventory)
        return cell
    }
    
    func getProducts(JsonCodes: String) {
        let JsonURLString = "https://shopicruit.myshopify.com/admin/products.json?ids=" + JsonCodes + "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: JsonURLString) else { return }
        //Create a separate thread to deal with the data
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else{
                return
            }
            do {
                //This is to grab the products data
                let productData = try JSONDecoder().decode(Products.self, from: data)
                let numb = productData.products.count
                for iter in 0...numb-1{
                    self.productsArray.append(productData.products[iter])
                }
                DispatchQueue.main.async{
                    //Anything I need to complete after the thread ends.
                    self.tableList.reloadData()
                }
            } catch let jsonError {
                print("Error: ", jsonError)
            }
            }.resume()
    }
    
    func addVariants(currentProduct: Product) -> Int {
        var totalInventory = 0
        for iter in 0...currentProduct.variants.count-1{
            totalInventory = totalInventory + currentProduct.variants[iter].inventory_quantity
        }
        return totalInventory
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        var productCodes = ""
        for iter in 0...productIds.count-1{
            productCodes = productCodes + String(productIds[iter])
            if iter < productIds.count-1{
                productCodes = productCodes + ","
            }
        }
        self.title = collectionTitle
        getProducts(JsonCodes: productCodes)
    }
    

}
