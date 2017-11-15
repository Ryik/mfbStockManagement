//
//  BackEnd.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 15/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

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
        Alamofire.request(ProductRouter.post(parameters.json.object as! [String : Any])).responseJSON { request in
            print(request)
            
        }
    }
    
    func get_records()  {
        var saveJSON : [Product] = []
        
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
        }
        
        
    }
}

