//
//  PaymentModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class PaymentModel: NSObject {
    var id: String?
    var cardName: String?
    var cardNumber: String?
    var cardExpiry: String?
    var cardCVV: String?
    var cardCountry: String?
    var cardOrder: Int?
    var cardType: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.cardName = json["cardName"] as? String ?? ""
        self.cardExpiry = json["cardExpiry"] as? String ?? ""
        self.cardExpiry = json["cardExpiry"] as? String ?? ""
        self.cardCVV = json["cardCVV"] as? String ?? ""
        self.cardCountry = json["cardCountry"] as? String ?? ""
        self.cardOrder = json["cardOrder"] as? Int ?? 0
        self.cardType = json["cardType"] as? String ?? ""
    }
}
