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
    var type: String?
    var main: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.main = json["main"] as? String ?? ""
    }

}
