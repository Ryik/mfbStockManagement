//
//  JsonApiCollection.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 15/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonApiCollection {
    var json: JSON
    
    
    init(json: JSON) {
        self.json = json
    }
    
    
    
    func create_entities() -> [Entity] {
        var entities = [Entity]()
        let data: JSON = json["data"]
        entities = data.arrayValue.map({ json_entity in
            let json_entity_type = json_entity["type"]
            let typ = Dic.dico[json_entity_type.stringValue]!
            return typ.init(json: json_entity["attributes"])
        })
        return entities
    }
}
