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

protocol OrganisationTableViewControllerDelegate: class {
    func addItemOrganisationControllerDidCancel(controller : OrganisationTableViewController)
    func addItemOrganisationController(controller: OrganisationTableViewController, didFinishingdAdding item: String)
}

class OrganisationTableViewController: UITableViewController  {
    
    weak var delegate : OrganisationTableViewControllerDelegate?
    
    @IBOutlet var OrganisationTableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var organisationName = [String]()
    var filteredOrganisationName = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search organisation name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        Alamofire.request(ProductRouter.getOrganisations).responseJSON { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /products")
                print(response.result.error!)
                return
            }
            
            // make sure we got some JSON since that's what we expect
            guard let json = JSON(response.result.value) as? JSON else {
                print("didn't get organisations object as JSON from API")
                print("Error: \(String(describing:response.result.error))")
                return
            }
            
            // get and print the title
            guard let organisations = json["data"] as? JSON else {
                print("Could not get organisation from JSON")
                return
            }
            var i = 0
            while (organisations[i] != JSON.null) {
                self.organisationName.append(organisations[i]["attributes"]["name"].string!)
                i = i + 1
            }
            
            self.OrganisationTableView.reloadData()
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
            return filteredOrganisationName.count
        }
        
        return organisationName.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name: String
        if isFiltering() {
            name = filteredOrganisationName[indexPath.row]
        } else {
            name = organisationName[indexPath.row]
        }
        cell.textLabel!.text = name
        return cell
    }
    // MARK: - Search Bar
    
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredOrganisationName = organisationName.filter({( name : String) -> Bool in
            return name.lowercased().contains(searchText.lowercased())
        })
        
        self.OrganisationTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK :- Click on cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var name: String = organisationName[indexPath.row]
        if isFiltering() {
            name = filteredOrganisationName[indexPath.row]
        }
        delegate?.addItemOrganisationController(controller: self, didFinishingdAdding: name)
        navigationController?.popViewController(animated: true)
        
    }
}


extension OrganisationTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}





