//
//  ProductRouter.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 06/11/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import Alamofire


enum ProductRouter: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000/"
    
    
    
    case getProducts
    case getOrganisations
    case post([String : Any])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getProducts, .getOrganisations:
                return .get
            case .post:
                return .post
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getProducts, .getOrganisations:
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
            case .getOrganisations:
                relativePath = "organisations"
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
