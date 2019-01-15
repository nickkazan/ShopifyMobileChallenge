//
//  Products.swift
//  ShopifyMobileChallenge
//
//  Created by Nick Kazan on 2019-01-09.
//  Copyright © 2019 Nick Kazan. All rights reserved.
//

import Foundation
import UIKit

struct Product: Decodable {
    let id: Int
    let title: String
    let body_html: String
    let vendor: String
    let product_type: String
    let created_at: String
    let handle: String
    let updated_at: String
    let published_at: String
    let template_suffix: String
    let tags: String
    let published_scope: String
    let admin_graphql_api_id: String
}

struct Products: Decodable {
    let products: [Product]
    
    func grabProducts() -> [Product] {
        
        var products = [Product]()
        
        let jsonURLStringProduct = "https://shopicruit.myshopify.com/admin/products.json?ids=2759137027,2759143811&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let urlP = URL(string: jsonURLStringProduct) else { return products }
        URLSession.shared.dataTask(with: urlP) { (data, response, err) in
            guard let data = data else{
                return
            }
            do {
                let productData = try JSONDecoder().decode(Products.self, from: data)
                let numb = productData.products.count
                for iter in 0...numb-1{
                    products.append(productData.products[iter])
                }
                
            } catch let jsonError {
                print("Error: ", jsonError)
            }
            }.resume()
        return products
    }
}



