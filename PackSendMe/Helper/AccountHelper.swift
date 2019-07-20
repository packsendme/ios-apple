//
//  AccountHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit


class AccountHelper: NSObject {
    
    
    var addressParser = ParserHelper()
    
    func transformObjectToArray(username:String, email:String, name:String, lastName:String, dateCreation:String,dateUpdate:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["name"] = name
        paramsDictionary["lastName"] = lastName
        paramsDictionary["dateCreation"] = dateCreation
        paramsDictionary["dateUpdate"] = dateUpdate
        return paramsDictionary
    }
    
    
    func addressObjectToArray(username:String, address:String, type:String, main:String, dateUpdate:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["dateUpdate"] = dateUpdate
        paramsDictionary["address"] = address
        paramsDictionary["type"] = type
        paramsDictionary["main"] = main
        return paramsDictionary
    }
  
    
    func transformArrayToAccountModel(account:[String:Any]) -> AccountModel {
        let accountArray = account["body"] as! [String:Any]
        let account = AccountModel(json: accountArray)
        let addressObj = AddressModel()
        var addressCollection = [AddressModel]()
        let addressArray = accountArray["address"] as? [[String:Any]]

        if(addressArray != nil){
            for address in addressArray! {
                if let id = address["id"] as? String {
                    addressObj.id = id
                }
                if let address = address["address"] as? String {
                    addressObj.address = address
                }
                if let type = address["type"] as? String {
                    addressObj.type = type
                }
                if let main = address["main"] as? String {
                    addressObj.main = main
                }
                addressCollection.append(addressObj)
            }
        }
        account.address = addressCollection
        return account
    }
    
    
    func getMenuConfiguration(jsonAccount : [String: Any]) -> AccountDto{
        
        var addressCollection = [AddressDto]()
        var addressNamesL : [String] = [""]

        var menuconfigAccountObj = AccountDto()
        var addressObj = AddressDto()
        
        // PERSONAL INFORMATION
        menuconfigAccountObj.name = jsonAccount["name"] as? String
        menuconfigAccountObj.username = jsonAccount["username"] as? String
        menuconfigAccountObj.email = jsonAccount["email"] as? String
        menuconfigAccountObj.lastName = jsonAccount["lastName"] as? String
        menuconfigAccountObj.dateCreation = jsonAccount["dateCreation"] as? String
        
        // ADDRESS INFORMATION
        let addressArray = jsonAccount["address"] as? [[String:Any]]
       
        if addressArray != nil {
            for address in addressArray! {
                if address["main"] as! String == GlobalVariables.sharedManager.addressMain {
                    let nameDescription = address["address"] as? String
                    addressObj.type =  address["type"] as? String
                    addressObj.main =  address["main"] as? String
                    addressNamesL = addressParser.addressParser(addressParser: nameDescription!)
                    addressObj.address = addressNamesL[0]
                    addressObj.city = addressNamesL[1]
                    addressObj.country = addressNamesL[2]
                    addressCollection.append(addressObj)
                    addressObj = AddressDto()
                }
            }
        }
        menuconfigAccountObj.address = addressCollection
        return menuconfigAccountObj
    }

}
