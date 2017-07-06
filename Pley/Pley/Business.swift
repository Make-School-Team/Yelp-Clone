//
//  Business.swift
//  Pley
//
//  Created by Zhaoya Sun on 7/5/17.
//  Copyright © 2017 Chenyang Zhang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Business {
    var name: String = ""
    var rating: Double = 0.0
    var location: String = ""
    var price: String = ""
    var distance: Double = 0.0
    var types: String = ""
    var phoneNumber: String = ""
    var imageURL: String = ""
    
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.rating = json["rating"].doubleValue
        self.location = "\(json["location"]["address1"].stringValue), \(json["location"]["city"].stringValue)"
        self.price = json["price"].stringValue
        self.distance = json["distance"].doubleValue
        self.phoneNumber = json["phone"].stringValue
        self.imageURL = json["image_url"].stringValue
        let types = json["categories"].arrayValue
        for type in types {
            if self.types == "" {
                self.types.append(type["alias"].stringValue)
            } else {
                self.types.append(", \(type["alias"].stringValue)")
            }
        }
        
    }
}
