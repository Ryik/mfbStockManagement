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

    
    var productName = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://localhost:3000").responseJSON { response in
            guard let json = response.result.value as? [String : NSArray] else { return print("FirstNOP") }
            let doc: NSArray = json["data"]!
//            print(json.count) //Probleme, on a un dico à un seul élément
//            print(doc[1])
            print(doc[0])
            let dic = doc[0]
            print(dic["type"])
            let okok = JSON(json)
//            print(okok)
            let arrayNames =  okok["id"].stringValue
//            print(okok["name"])
            
            
            
//            print(json)
//            print("\nJSON récupéré\n")                    ok
//            print(json["data"])
//            print("json Data field accessed")             ok
//            let data = json["data"]
//            print(data)
//            let name = try? JSONSerialization.jsonObject(with: data) as? [String : Any]
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return productName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel!.text = productName[indexPath.row]
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
