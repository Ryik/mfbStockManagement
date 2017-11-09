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
    static let baseURLString = "http://localhost:3000"
    
    case get
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .get:
                return nil
            }
        }()
        
        let url: URL = {
            // build up and return the URL for each endpoint
            let relativePath: String?
            switch self {
            case .get:
                relativePath = "products"
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
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: params)
    }
}
