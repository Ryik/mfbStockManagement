//
//  Stock.swift
//  MFB_IOS_PROJECT
//
//  Created by Gabriel Morin on 31/10/2017.
//  Copyright © 2017 Honeywell Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Ressource {
    var article: String!
    var qtity: Int! = 0
    var colisage: Int! = 0
    var pckgPerLevel: Int! = 0
    var level : Int! = 0
    var surplus: Int! = 0
    var owner: String!
    var date: Date!
    var code : Captuvo!
}
