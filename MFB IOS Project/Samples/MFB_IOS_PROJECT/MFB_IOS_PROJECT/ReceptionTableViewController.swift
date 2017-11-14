//
//  ReceptionTableViewController.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 31/10/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ReceptionTableViewController: UITableViewController {

    


    @IBOutlet var ProductTableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var productName = [String]()
    var filteredProductName = [String]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search product name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        Alamofire.request(ProductRouter.get).responseJSON { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /products")
                print(response.result.error!)
                return
            }
            
            // make sure we got some JSON since that's what we expect
            guard let json = JSON(response.result.value) as? JSON else {
                print("didn't get products object as JSON from API")
                print("Error: \(String(describing:response.result.error))")
                return
            }
            
            // get and print the title
            guard let products = json["data"] as? JSON else {
                print("Could not get products from JSON")
                return
            }
            var i = 0
            while (products[i] != JSON.null) {
                self.productName.append(products[i]["attributes"]["name"].string!)
                i = i + 1
            }

            self.ProductTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredProductName.count
        }
        
        return productName.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name: String
        if isFiltering() {
            name = filteredProductName[indexPath.row]
        } else {
            name = productName[indexPath.row]
        }
        cell.textLabel!.text = name
        return cell
    }
    // MARK: - Search Bar
    

    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProductName = productName.filter({( name : String) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        
        self.ProductTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK : - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductChoosedSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                var name : String! = productName[indexPath.row]
                if isFiltering() {
                    name = filteredProductName[indexPath.row]
                }
                let controller = (segue.destination as! ViewController)
//                controller.productName = name
            }
        }
    }
}


extension ReceptionTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}



