//
//  AddressModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 08/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AddressModel: NSObject {
    
    var id: String?
    var address: String?
    var number: String?
    var stateorprovince: String?
    var postalcode: String?
    var city: String?
    var country: String?
    var type: String?
    var composite: String?
    var latitude: String?
    var longitude: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.number = json["number"] as? String ?? ""
        self.stateorprovince = json["stateorprovince"] as? String ?? ""
        self.postalcode = json["postalcode"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.composite = json["composite"] as? String ?? ""
        self.latitude = json["latitude"] as? String ?? ""
        self.longitude = json["longitude"] as? String ?? ""
    }

}
