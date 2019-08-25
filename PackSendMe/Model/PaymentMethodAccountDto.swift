//
//  PaymentAllDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

//class PaymentMethodAccountDto: NSObject {
public struct PaymentMethodAccountDto: Codable {
    var titleHead: String?
    var payName: String?
    var payCodenum: String?
    var payCountry: String?
    var payEntity: String?
    var payType: String?
    var payExpiry: String?
    var payStatus: String?
    var payValue: String?
    var dateCreation: String?
    var dateUpdate: String?


    
 /*
    init(json: [String: Any]) {
        self.username = json["username"] as? String ?? ""
        self.payName = json["payName"] as? String ?? ""
        self.payCodenum = json["payCodenum"] as? String ?? ""
        self.payGeneralType = json["payGeneralType"] as? String ?? ""
        self.payType = json["payType"] as? String ?? ""
        self.payExpiry = json["payExpiry"] as? String ?? ""
        self.payStatus = json["payStatus"] as? String ?? ""
        self.payValue = json["payValue"] as? String ?? ""
        self.dateCreation = json["dateCreation"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
    }
    */
}
