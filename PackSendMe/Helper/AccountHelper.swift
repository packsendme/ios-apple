//
//  AccountHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AccountHelper: NSObject {
    
    func transformObject(username:String, email:String, password:String, name:String, lastname:String, address:[AddressModel], dtAction:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["password"] = password
        paramsDictionary["name"] = name
        paramsDictionary["lastname"] = lastname
        paramsDictionary["address"] = address
        paramsDictionary["dtAction"] = dtAction
        return paramsDictionary
    }
    

}
