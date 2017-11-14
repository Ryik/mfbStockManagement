//: Playground - noun: a place where people can play

import UIKit
import Alamofire
import SwiftyJSON
import Foundation
import Pods_MFB_IOS_PROJECT

import XCPlayground


var str = "Hello, playground"
print(str)

class JsonApiInstance {
    var json : JSON
    
    init(json: JSON) {
        self.json = json
    }
    
    init(id: Int?, attributes: JSON , type: JSON) {
        let parameters: JSON =
            [
                "data": [
                    "id" : id as Any,
                    "attributes" :  attributes,
                    "type": type
                ]
        ]
        json = JSON.null
        self.post_request(parameters: parameters)
        
    }
    
    static func create_from_entity(entity: Entity) -> JsonApiInstance {
        return JsonApiInstance(id: entity.id, attributes: entity.attributes , type: JSON(type(of: entity).json_api_type))
        
    }
    
    
    func post_request(parameters : JSON) {
        XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

        Alamofire.request(ProductRouter.post(parameters.object as! [String : Any])).responseJSON { request in
         print(request)
         print("test")
         XCPlaygroundPage.currentPage.needsIndefiniteExecution = false
         }
    }
}

func create_post_dictionnary (product_id : Int, owner_id : Int, container_id : Int, location_id : Int,
                              quantity_value : String, quantity_unit_of_measure : String, receipt_datetime : String,
                              memo : String?, type : String) -> [String: Any] {
    let parameters: [String: Any] =
        [
            "data": [
                "attributes" :  [
                    "product-id" : product_id,
                    "owner-id" : owner_id,
                    "container-id" : container_id,
                    "location-id" : location_id,
                    "quantity-value" : quantity_value,
                    "quantity-unit-of-measure" : quantity_unit_of_measure,
                    "receipt-datetime" : receipt_datetime,
                    "memo": memo as Any
                ],
                "type": type
            ]
    ]
    return parameters
}


class JsonApiCollection {
    var json: JSON
    
    
    init(json: JSON) {
        self.json = json
    }
    
    func create_product() -> [Product] {
        var products : [Product] = []
        var i = 0
        while (json[i] != JSON.null) {
            let name = (json[i]["attributes"]["name"])
            let base = (json[i]["attributes"]["base-unit-of-measure"])
            let tempJson : JSON = ["name" : name, "base-unit-of-measure" : base]
            let temp : Product = Product(json : tempJson)
            //     print(temp)
            products.append(temp)
            i = i + 1
        }
        return products
    }
    
    //static func create_entity(json: JSON) -> Entity {
    //    let data = json["data"] as! JSON
    //    return Product(json: data["attributes"])
    //}
}

enum ProductRouter: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000/"
    
    case get
    case post([String : Any])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .post:
                return .post
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .get:
                return nil
            case .post(let newEntity):
                return (newEntity)
            }
        }()
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .get:
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

class BackEnd {
    
    func shipment_request(parameters : [String : Any]) {
        Alamofire.request(ProductRouter.post(parameters)).responseJSON { request in
            print(request)
        }
    }
    
    static func get_all() -> [Product] {
        var saveJSON : [Product] = []
        
        Alamofire.request(ProductRouter.get).responseJSON { response in
            // check for errors
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /products")
                print(response.result.error!)
                return
            }
            
            // make sure we got some JSON since that's what we expect
            guard let json = JSON(response.result.value as Any) as? JSON else {
                print("didn't get products object as JSON from API")
                print("Error: (String(describing:response.result.error))")
                return
            }
            
            // get and print the title
            guard let products = json["data"] as? JSON else {
                print("Could not get products from JSON")
                return
            }
            let jsonapicollection : JsonApiCollection = JsonApiCollection(json: products)
            saveJSON = jsonapicollection.create_product()
        }
        return saveJSON
    }
}

class Entity {
    
    // static func from_json_api(json_api: JSON) {
    //    JsonApi.create_entity()
    //}
    var attributes: JSON
    static let json_api_type : String = "products"
    
    
    init(json: JSON) {
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
    
    // static backEnd: BackEnd = BackEnd("Product")
    
    
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
    
    /*    static func get_products() -> [Product] {
     return backEnd.get_all()
     }*/
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


