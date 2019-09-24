//
//  PaymentAllDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

public struct PaymentAccountDto: Codable {
    var titleHead: String?
    var payName: String?
    var payCodenum: String?
    var payCountry: String?
    var payEntity: String?
    var payType: String?
    var payExpiry: String?
    var payStatus: String?
    var payValue: String?
    var dateOperation: String?
    var operationTransaction: String?


    /*
    init(json: [String: Any]) {
        self.titleHead = json["titleHead"] as? String ?? ""
        self.usernamephnumber = json["usernamephnumber"] as? String ?? ""
        self.payName = json["payName"] as? String ?? ""
        self.payCodenum = json["payCodenum"] as? String ?? ""
        self.payCountry = json["payCountry"] as? String ?? ""
        self.payEntity = json["payEntity"] as? String ?? ""
        self.payType = json["payType"] as? String ?? ""
        self.payExpiry = json["payExpiry"] as? String ?? ""
        self.payStatus = json["payStatus"] as? String ?? ""
        self.payValue = json["payValue"] as? String ?? ""
        self.dateOperation = json["dateOperation"] as? String ?? ""
    }
     
     paymentAccountObj.createPaymentDictionary(usernamephnumber:GlobalVariables.sharedManager.usernameNumberphone, payName:"", payCodenum:cardPaymentDto.payCodenum!, payCountry:cardPaymentDto.payCountry!, payEntity:cardPaymentDto.payEntity!, payType:cardPaymentDto.payType!, payExpiry:cardPaymentDto.payExpiry!, payStatus:cardPaymentDto.payStatus!, payValue:cardPaymentDto.payValue!, dateOperation:cardPaymentDto.dateOperation!)
     
     
    */
    func createPaymentDictionary(payName:String, payCodenum:String, payCountry:String, payEntity:String, payType:String, payExpiry:String, payStatus:String, payValue:String, dateOperation:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["payName"] = payName
        paramsDictionary["payCodenum"] = payCodenum
        paramsDictionary["payCountry"] = payCountry
        paramsDictionary["payEntity"] = payEntity
        paramsDictionary["payType"] = payType
        paramsDictionary["payExpiry"] = payExpiry
        paramsDictionary["payStatus"] = payStatus
        paramsDictionary["payValue"] = payValue
        paramsDictionary["dateOperation"] = dateOperation
        return paramsDictionary
    }
    
    func createDictionaryToValidateCard(payCodenum:String, payCountry:String, payEntity:String, payExpiry:String, payValue:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["payCodenum"] = payCodenum
        paramsDictionary["payCountry"] = payCountry
        paramsDictionary["payEntity"] = payEntity
        paramsDictionary["payExpiry"] = payExpiry
        paramsDictionary["payValue"] = payValue
        return paramsDictionary
    }
   
}
