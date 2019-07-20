//
//  PaymentAllDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class PaymentAllDto: NSObject {
    
    var desc1: String?
    var desc2: String?
    var desc3: String?
    var desc4: String?
    var desc5: String?

    override init() {
    }
    
    init(json: [String: Any]) {
        self.desc1 = json["desc1"] as? String ?? ""
        self.desc1 = json["desc2"] as? String ?? ""
        self.desc3 = json["desc3"] as? String ?? ""
        self.desc4 = json["desc4"] as? String ?? ""
        self.desc5 = json["desc5"] as? String ?? ""

    }

}
