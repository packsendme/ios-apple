//
//  PaymentAccountDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//


import UIKit

class PaymentAccountDto {
    var id: String?
    var username: String?
    //var payment: [PaymentModel]?
    var dateCreation: String?
    var dateUpdate: String?
    
    init() {
        
    }
    
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.dateCreation = json["dateCreation"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
       // self.payment = json["payment"] as? [PaymentModel] ?? nil
    }
}

