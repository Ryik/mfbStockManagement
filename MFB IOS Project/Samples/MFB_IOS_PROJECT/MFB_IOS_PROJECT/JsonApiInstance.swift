//
//  JsonApiInstance.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 15/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonApiInstance {
    var json : JSON
    
    init(json: JSON) {
        self.json = json
    }
    
    init(id: Int?, attributes: JSON , type: JSON) {
        self.json = JSON()
        
        json["data"] = JSON()
        json["data"]["id"] = JSON(id as Any)
        json["data"]["attributes"] = attributes
        json["data"]["type"] = type
    }
    
    static func create_from_entity(entity: Entity) -> JsonApiInstance {
        return JsonApiInstance(id: entity.id, attributes: entity.attributes , type: JSON(type(of: entity).json_api_type))
        
    }
    
    func create_entity() -> Entity {
        let data = json["data"]
        if (data["type"] == "products") {
            return Product(json: data["attributes"])
        }
        
        return Entity(json: JSON.null)
    }
    
}
