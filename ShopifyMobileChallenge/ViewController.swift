//
//  ViewController.swift
//  ShopifyMobileChallenge
//
//  Created by Nick Kazan on 2019-01-07.
//  Copyright © 2019 Nick Kazan. All rights reserved.
//

import UIKit

//All of the following structs are used to hold the data from the api. Anything that is greyed out is available for use if need be, however did not apply to this challenge specifically.
struct CustomCollection: Decodable {
    let custom_collections: [Collection]
}
struct Collection: Decodable {
    let id: Int
    //let handle: String
    let title: String
    //let updated_at: String
    //let body_html: String
    //let published_at: String
    //let template_suffix: String
    //let published_scope: String
    //let admin_graphql_api_id: String
    let image: Image
    struct Image: Decodable {
        //let created_at: String
        //let alt: String?
        //let width: Int
        //let height: Int
        let src: String
    }
}

struct Collects: Decodable {
    let collects: [Collect]
    struct Collect: Decodable {
        let id: Int
        let collection_id: Int
        let product_id: Int
        //let featured: Bool
        //let created_at: String
        //let updated_at: String
        //let position: Int
        //let sort_value: String
    }
}
//Relates to the intial view controller
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableList: UITableView!
    
    var tempCollectionTitle = String()
    var collectsArray = [Int]()
    var collections = [Collection]()
    var tempCollectionImage = String()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //grabs the prototype cell with the identifier 'cell'
        let cell = tableList.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.setCollection(collection: collections[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentID = collections[indexPath.row].id
        tempCollectionTitle = collections[indexPath.row].title
        tempCollectionImage = collections[indexPath.row].image.src
        grabCollects(id: currentID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //First we need to grab our data
        self.title = "Categories"
        let jsonURLStringCollection = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let urlC = URL(string: jsonURLStringCollection) else {
            //This should not be tripped, but just here for good practice
            return
        }
        //Create a separate thread to deal with the data
        URLSession.shared.dataTask(with: urlC) { (data, response, err) in
            guard let data = data else{
                //Same as above
                return
            }
            do {
                //This is to grab the collections data
                let collectionData = try JSONDecoder().decode(CustomCollection.self, from: data)
                let numb = collectionData.custom_collections.count
                for iter in 0...numb-1{
                    self.collections.append(collectionData.custom_collections[iter])
                }
                //.sync could have been used because we are waiting for this result to proceed anyways. I chose async if I ever needed to complete concurrent tasks in the future.
                DispatchQueue.main.async{
                    self.tableList.reloadData()
                }
            } catch let jsonError {
                print("Error: ", jsonError)
            }
        }.resume()
    }
    //Change the top bar to white(Physical Device)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func grabCollects(id: Int) {
        var jsonURLStringCollect = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
        jsonURLStringCollect = jsonURLStringCollect + String(id) + "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: jsonURLStringCollect) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else{
                return
            }
            do {
                let collectData = try JSONDecoder().decode(Collects.self, from: data)
                let numb = collectData.collects.count
                //Remove items so when you change collections, it doesn't append all of them
                self.collectsArray.removeAll()
                for iter in 0...numb-1{
                    self.collectsArray.append(collectData.collects[iter].product_id)
                }
                DispatchQueue.main.async{
                    //Anything I need to complete after the thread ends.
                    self.performSegue(withIdentifier: "mySegue", sender: nil)
                }
            } catch let jsonError {
                print("Error: ", jsonError)
            }
        }.resume()
    }
    //What we need to do before performSeque()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! SecondViewController
        
        secondVC.productIds = collectsArray
        secondVC.collectionTitle = tempCollectionTitle
        secondVC.collectionImage = tempCollectionImage
    }
}
