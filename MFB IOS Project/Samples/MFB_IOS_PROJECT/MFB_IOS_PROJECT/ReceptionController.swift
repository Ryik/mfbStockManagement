//
//  Reception.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 16/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import UIKit
import Eureka

class ReceptionController : FormViewController, ReceptionTableViewControllerDelegate, OrganisationTableViewControllerDelegate {
    func addItemOrganisationControllerDidCancel(controller: OrganisationTableViewController) {
    }
    
    func addItemOrganisationController(controller: OrganisationTableViewController, didFinishingdAdding item: String) {
        product.owner = item
        refreshingOwner?.title = item
        refreshingOwner?.reload()
    }
    
    
    func addItemReceptionControllerDidCancel(controller: ReceptionTableViewController) {
    }
    
    func addItemReceptionController(controller: ReceptionTableViewController, didFinishingdAdding item: String) {
        product.article = item
        refreshingProductName?.title = item
        refreshingProductName?.reload()
    }
    

    let product : Ressource = Ressource()
    var refreshingProductName : TextRow?
    var refreshingOwner : TextRow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Formulaire de réception")
            <<< IntRow() { row in
                row.title = "Colisage"
                row.placeholder = "Ecrivez ici"
                }.onChange { row in
                    self.product.colisage = row.value
            }
            
            <<< IntRow() { row in
                row.title = "Nombre de colis par étage"
                row.placeholder = "Ecrivez ici"
                }.onChange { row in
                    self.product.pckgPerLevel = row.value
            }
            
            <<< IntRow() { row in
                row.title = "Nombre d'étages"
                row.placeholder = "Ecrivez ici"
                }.onChange { row in
                    self.product.level = row.value
                    
            }
            
            <<< IntRow() { row in
                row.title = "Nombre de pièces en surplus"
                row.placeholder = "Ecrivez ici"
                }.onChange { row in
                    self.product.surplus = row.value
        }
        
        form +++ Section("Liste déroulante")
            <<< TextRow() { row in
                row.title = "                       Aucun article choisi"
                refreshingProductName = row
            }
            <<< ButtonRow() { button in
                button.title = "Article"
                button.onCellSelection(self.actingSegues)
            }
            <<< TextRow() { row in
                row.title = "                  Aucun propriétaire choisi"
                refreshingOwner = row
            }
            <<< ButtonRow() { button in
                button.title = "Propriétaire"
               button.onCellSelection(self.actingSegues)
        }
        form +++ Section("Date de réception")
            <<< DateRow() { row in
                row.title = "Date"
                row.value = Date(timeIntervalSinceReferenceDate: 0)
        }
        
        
        // A FAIRE QUAND ON VALIDE LA RECEPTION
        // product.qtity = product.colisage * product.pckgPerLevel * product.level + product.surplus
    }
    
    func actingSegues(cell : ButtonCellOf<String> ,row: ButtonRow) {
        let segue : String = row.title! + "Segue"
        performSegue(withIdentifier: segue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ArticleSegue") {
            let controller = segue.destination as! ReceptionTableViewController
            controller.delegate = self
        }
        if (segue.identifier == "PropriétaireSegue") {
            let controller = segue.destination as! OrganisationTableViewController
            controller.delegate = self
        }
    }
}
