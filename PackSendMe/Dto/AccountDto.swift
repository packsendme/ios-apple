//
//  AccountDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class AccountDto: NSObject {
    
    var username: String?
    var email: String?
    var name: String?
    var password: String?
    var lastName: String?
    var codcountry: String?
    var dateCreation : String?
    var dateUpdate : String?
    var address: [AddressDto]?
    
    override init() {
        
    }
    
    init(json: [String: Any]) {
        self.username = json["username"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.lastName = json["lastName"] as? String ?? ""
        self.codcountry = json["codcountry"] as? String ?? ""
        self.dateCreation = json["dateCreation"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
        self.address = json["address"] as? [AddressDto] ?? nil
    }
    
    func createAccountDictionary(username:String, email:String, password:String, name:String, lastName:String, codcountry:String,dateCreation:String,dateUpdate:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["name"] = name
        paramsDictionary["password"] = password
        paramsDictionary["lastName"] = lastName
        paramsDictionary["codcountry"] = codcountry
        paramsDictionary["dateCreation"] = dateCreation
        paramsDictionary["dateUpdate"] = dateUpdate
        return paramsDictionary
    }
}
