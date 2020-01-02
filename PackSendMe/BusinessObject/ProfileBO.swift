//
//  AccountDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

public struct ProfileBO{
    
    var username: String?
    var email: String?
    var name: String?
    var password: String?
    var lastName: String?
    var country: String?
    var dateOperation : String?
    var address: [AddressBO]?
    
    func createAccountDictionary(username:String, email:String, password:String, name:String, lastName:String, country:String,dateOperation:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["name"] = name
        paramsDictionary["password"] = password
        paramsDictionary["lastName"] = lastName
        paramsDictionary["country"] = country
        paramsDictionary["dateOperation"] = dateOperation
        return paramsDictionary
    }
    
    func createAccountObject(jsonAccount:[String:Any]) -> ProfileBO {
        let profileObj = ProfileBO(
            username: jsonAccount["username"] as? String,
            email: jsonAccount["email"] as? String,
            name: jsonAccount["name"] as? String,
            password: jsonAccount["lastName"] as? String,
            lastName: jsonAccount["lastName"] as? String,
            country: jsonAccount["country"] as? String,
            dateOperation: jsonAccount["dateOperation"] as? String,
            address: nil)
        return profileObj
    }
    
    func createAccountAddressObject(jsonAccount : [String: Any]) -> ProfileBO{
        let addressObj = AddressBO()
        var addressCollection = [AddressBO]()
        addressCollection = addressObj.createAddressArray(jsonAddress: jsonAccount)
        
        let profileObj = ProfileBO(
            username: jsonAccount["username"] as? String,
            email: jsonAccount["email"] as? String,
            name: jsonAccount["name"] as? String,
            password: jsonAccount["lastName"] as? String,
            lastName: jsonAccount["lastName"] as? String,
            country: jsonAccount["country"] as? String,
            dateOperation: jsonAccount["dateOperation"] as? String,
            address: addressCollection)
         return profileObj
    }
}
