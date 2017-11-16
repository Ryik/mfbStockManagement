//
//  ViewController.swift
//  SwiftSample
//
//  Created by zhou shadow on 5/6/15.
//  Copyright (c) 2015 Honeywell Inc. All rights reserved.
//

import UIKit
import Alamofire
import Eureka

class ViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Choisissez votre action")
            <<< ButtonRow() { button in
                button.title = "Réception de marchandises"
                button.onCellSelection(self.buttonTapped)
        }
            <<< ButtonRow() { button in
                button.title = "Création de stock"
                button.onCellSelection(self.buttonTapped)
        }
            <<< ButtonRow() { button in
                button.title = "Préparation de production "
                button.onCellSelection(self.buttonTapped)
        }
            <<< ButtonRow() { button in
                button.title = "Départ (picking)"
                button.onCellSelection(self.buttonTapped)
        }
            <<< ButtonRow() { button in
                button.title = "Déplacement de palettes"
                button.onCellSelection(self.buttonTapped)
        }
            <<< ButtonRow() { button in
                button.title = "Inventaire"
                button.onCellSelection(self.buttonTapped)
        }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        performSegue(withIdentifier: row.title!, sender: nil)
    }
    
}
