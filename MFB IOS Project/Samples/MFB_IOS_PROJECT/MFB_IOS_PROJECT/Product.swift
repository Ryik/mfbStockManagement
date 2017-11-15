//
//  Product.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 15/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class Product : Entity {
    
    static var backEnd: BackEnd = BackEnd()
    
    var name: String? {
        get {
            return attributes["name"].string
        }
        set {
            attributes["name"] = JSON(newValue as Any)
        }
    }
    var base_unit_of_measure: String? {
        get {
            return attributes["base-unit-of-measure"].string
        }
        set {
            attributes["base-unit-of-measure"] = JSON(newValue as Any)
        }
    }
}
