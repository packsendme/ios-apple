//
//  AccountHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class ObjectTransformHelper: NSObject {
    
    func accountTransformObject(username:String, email:String, password:String, name:String, lastname:String, address:[AddressModel], dtAction:String) -> Dictionary<String, Any> {
        
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
    
    func arrayToAccountModelObj(account:[String:Any]) -> AccountModel {
        let accountArray = account["body"] as! [String:Any]
        let account = AccountModel(json: accountArray)
        let addressObj = AddressModel()
        var addressCollection = [AddressModel]()
        
        let addressArray = accountArray["address"] as? [[String:Any]]

        for address in addressArray! {
                
            if let address = address["address"] as? String {
                addressObj.address = address
            }
            if let number = address["number"] as? String {
                addressObj.number = number
            }
            if let stateorprovince = address["stateorprovince"] as? String {
                addressObj.stateorprovince = stateorprovince
            }
            if let postalcode = address["postalcode"] as? String {
                addressObj.postalcode = postalcode
            }
            if let city = address["city"] as? String {
                addressObj.city = city
            }
            if let country = address["country"] as? String {
                addressObj.country = country
            }
            if let type = address["type"] as? String {
                addressObj.type = type
            }
            if let composite = address["composite"] as? String {
                addressObj.composite = composite
            }
            if let latitude = address["latitude"] as? String {
                addressObj.latitude = latitude
            }
            if let longitude = address["longitude"] as? String {
                addressObj.longitude = longitude
            }
            addressCollection.append(addressObj)
        }
        account.address = addressCollection
        return account
    }
    
    func userTransformObject(username:String, password:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary["username"] = username
        paramsDictionary["password"] = password
        return paramsDictionary
    }
    

}
