//
//  Entity.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 15/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class Entity {
    
    var attributes: JSON
    static let json_api_type : String = "products"
    
    static func fromJSON(jsonapi: JsonApiInstance) -> Entity {
        return jsonapi.create_entity()
    }
    
    required init(json: JSON) {
        self.attributes = json
    }
    
    func to_json() -> JsonApiInstance {
        return JsonApiInstance.create_from_entity(entity: self)
    }
    
    var id: Int? {
        get {
            return attributes["id"].int
        }
        set {
            attributes["id"] = JSON(newValue as Any)
        }
    }
    
    subscript(attribute: String) -> Any? {
        get {
            return attributes[attribute]
        }
        set {
            attributes[attribute] = JSON(newValue as Any)
        }
    }
}
