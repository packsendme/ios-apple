//
//  MethodPaymentModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 24/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class PaymentMethodModel: NSObject {
    var namePayMethod: String?
    var typePayMethod: String?
    var status: String?
    
    override init() {
    }
    
    init(json: [String: Any]) {
        self.namePayMethod = json["namePayMethod"] as? String ?? ""
        self.typePayMethod = json["typePayMethod"] as? String ?? ""
        self.status = json["status"] as? String ?? ""
    }
}
