//
//  AccountModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 08/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AccountModel {
    var id: String?
    var username: String?
    var password: String?
    var email: String?
    var name: String?
    var lastName: String?
    var codcountry: String?
    var address: [AddressModel]?
    var dateCreation: String?
    var dateUpdate: String?
    
    init() {
        
    }
    
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.lastName = json["lastName"] as? String ?? ""
        self.codcountry = json["codcountry"] as? String ?? ""
        self.address = json["address"] as? [AddressModel] ?? nil
        self.dateCreation = json["dateCreation"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
        self.address = json["address"] as? [AddressModel] ?? nil
    }
}