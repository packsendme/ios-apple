//
//  AddressAccountModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 13/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class AddressAccountDto: NSObject {
    var username: String?
    var dateUpdate: String?
    var address: String?
    var type: String?
    var main: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.username = json["username"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.main = json["main"] as? String ?? ""
    }
}
