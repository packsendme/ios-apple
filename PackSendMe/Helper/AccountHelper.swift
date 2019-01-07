//
//  AccountHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 09/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class AccountHelper: NSObject {
    
    func transformObjectToArray(username:String, email:String, password:String, name:String, lastname:String, address:[AddressModel], dtCreation:String,dtChange:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary["username"] = username
        paramsDictionary["email"] = email
        paramsDictionary["password"] = password
        paramsDictionary["name"] = name
        paramsDictionary["lastname"] = lastname
        paramsDictionary["address"] = address
        paramsDictionary["dateCreation"] = dtCreation
        paramsDictionary["dateChange"] = dtChange
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
