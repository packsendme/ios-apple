//
//  AddressDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class AddressDto: NSObject {
    var address: String?
    var city: String?
    var country: String?
    var type: String?
    var main: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.address = json["address"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.main = json["main"] as? String ?? ""
    }
}
