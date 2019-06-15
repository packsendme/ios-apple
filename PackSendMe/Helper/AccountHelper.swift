//
//  AccountHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AccountHelper: NSObject {
    
    func transformObjectToArray(id:String, username:String, email:String, password:String, name:String, lastName:String, addressArray:[AddressModel], dateCreation:String,dateUpdate:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        var dicAddress = [String:Any]()
        var addressCollection = [Any]()
        
        paramsDictionary["id"] = id
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["password"] = password
        paramsDictionary["name"] = name
        paramsDictionary["lastName"] = lastName
        paramsDictionary["dateCreation"] = dateCreation
       // paramsDictionary["payment"] = []
        paramsDictionary["dateUpdate"] = dateUpdate
        
        print(" +++++++++++++++++++++++++++++++++++++++ ")
       
        if(addressArray != nil){
            for address in addressArray {
                dicAddress["id"] = address.id
                dicAddress["address"] = address.address
                dicAddress["type"] = address.type
                dicAddress["main"] = address.main
                addressCollection.append(dicAddress)
            }
        }
        paramsDictionary["address"] = addressCollection
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
        let payloadObj = PaymentModel()
        var addressCollection = [AddressModel]()
        var paymentCollection = [PaymentModel]()
        
        let paymentArray = accountArray["payment"] as? [[String:Any]]
        let addressArray = accountArray["address"] as? [[String:Any]]

        if(addressArray != nil){
            for address in addressArray! {
                if let id = address["id"] as? String {
                    addressObj.id = id
                }
                if let address = address["address"] as? String {
                    addressObj.address = address
                    print(" - ADDRESS - : ",addressObj.address)

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
        
        if(paymentArray != nil){
            for payment in paymentArray! {
                
                if let cardName = payment["cardName"] as? String {
                    payloadObj.cardName = cardName
                }
                if let cardNumber = payment["cardNumber"] as? String {
                    payloadObj.cardNumber = cardNumber
                }
                if let cardExpiry = payment["cardExpiry"] as? String {
                    payloadObj.cardExpiry = cardExpiry
                }
                if let cardCVV = payment["cardCVV"] as? String {
                    payloadObj.cardCVV = cardCVV
                }
                if let cardCountry = payment["cardCountry"] as? String {
                    payloadObj.cardCountry = cardCountry
                }
                paymentCollection.append(payloadObj)
            }
        }
        account.address = addressCollection
        account.payment = paymentCollection
        return account
    }
    
   

}
