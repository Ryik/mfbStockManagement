//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import Pods_MFB_IOS_PROJECT

import XCPlayground


var str = "Hello, playground"
print(str)

class Dic {
    static var dico : [String : Entity.Type] = ["products" : Product.self]
}

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

        //self.post_request(parameters: parameters)
        
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



class BackEnd {
    
    static var products = [Entity]()
    
    enum ProductRouter: URLRequestConvertible {
        static let baseURLString = "http://localhost:3000/"
        
        
        
        case getProducts
        case post([String : Any])
        
        func asURLRequest() throws -> URLRequest {
            var method: HTTPMethod {
                switch self {
                case .getProducts:
                    return .get
                case .post:
                    return .post
                }
            }
            
            let params: ([String: Any]?) = {
                switch self {
                case .getProducts:
                    return nil
                case .post(let newEntity):
                    return (newEntity)
                }
            }()
            
            let url: URL = {
                // build up and return the URL for each endpoint
                let relativePath: String?
                switch self {
                case .getProducts:
                    relativePath = "products"
                case .post:
                    relativePath = "shipment_receipts"
                }
                
                var url = URL(string: ProductRouter.baseURLString)!
                if let relativePath = relativePath {
                    url = url.appendingPathComponent(relativePath)
                }
                return url
            }()
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            let encoding: ParameterEncoding = {
                switch method {
                case .get:
                    return URLEncoding.default
                case .post:
                    return JSONEncoding.default
                default:
                    return JSONEncoding.default
                }
            }()
            return try encoding.encode(urlRequest, with: params)
        }
    }
    
    func post_record(parameters : JsonApiInstance) {
        
        XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
        
        Alamofire.request(ProductRouter.post(parameters.json.object as! [String : Any])).responseJSON { request in
            print(request)
            print("test")
            
            XCPlaygroundPage.currentPage.needsIndefiniteExecution = false
        }
    }
    
    func get_records()  {
        var saveJSON : [Product] = []
        
        XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

        Alamofire.request(ProductRouter.getProducts).responseJSON { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /products")
                print(response.result.error!)
                return
            }
            // make sure we got some JSON since that's what we expect
            guard let product : JSON = JSON(response.result.value as Any) else {
                print("didn't get products object as JSON from API")
                print("Error: (String(describing:response.result.error))")
                return
            }
            
            let jsonapicollection : JsonApiCollection = JsonApiCollection(json: product)
            saveJSON = jsonapicollection.create_entities() as! [Product]
            BackEnd.products = saveJSON
            
            XCPlaygroundPage.currentPage.needsIndefiniteExecution = false
        }
        
     
    }
}

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


let parameters: JSON =
    [
        "data": [
            "attributes" :  [
                "product-id" : 101,
                "owner-id" : 201,
                "container-id" : 109,
                "location-id" : 101,
                "quantity-value" : "1000.0",
                "quantity-unit-of-measure" : "u",
                "receipt-datetime" : "2016-12-13T00:00:00.000Z",
                "memo":"coucou"
            ],
            "type":"shipment-receipts"
        ]
]

