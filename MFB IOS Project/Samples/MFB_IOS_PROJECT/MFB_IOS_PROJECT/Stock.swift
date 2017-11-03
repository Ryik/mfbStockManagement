//
//  Stock.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 31/10/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation

class Ressource {
    var article: String!
    var qtity: Int?
    var colisage: Int?
    var pckgPerLevel: Int?
    var owner: String!
    var date: Date!
    var code : Captuvo!
}


//class Products {
//    let product = [Product]()
//    
//    init(json: [String : Any]) throws {
//        guard let result = json["name"] as? [String : Any] else {
//            print("ntm")
//        }
//        let product = result.map{ Product(json: $0) }.flatMap{ $0 }
//        self.product = product
//    }
//}
class Product {
    var id: String?
    var name: String?
    var type: String?
//    var unitBase: String?
    
    required init?(json: [String : Any]) {
        guard
            let id = json["id"] as? String,
            let name = json["name"] as? String,
            let type = json["type"] as? String else {
//            let unitBase = json["\"base-unit-of-measure\""] as? String else {
                return nil
        }
        self.id = id
        self.name = name
        self.type = type
//        self.unitBase = unitBase
        
    }
}
