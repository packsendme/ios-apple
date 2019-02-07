//
//  UserModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class UserModel {

    var id: String?
    var username: String?
    var password: String?
    var activated: Bool?
    var activationKey: String?
    var resetPasswordKey: Bool?
    var responseStatus: HttpResponseModel?
    var dateCreation: String?
    var dateUpdate: String?
    
    init() {
        
    }
  

    init(json: [String: Any]) {
        self.id = json["id"] as? String ?? ""
        self.username = json["username"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
        self.activated = json["activated"] as? Bool ?? false
        self.activationKey = json["activationKey"] as? String ?? ""
        self.resetPasswordKey = json["resetPasswordKey"] as? Bool ?? false
        self.dateCreation = json["dateCreation"] as? String ?? ""
        self.dateUpdate = json["dateUpdate"] as? String ?? ""
        
    }

    
    
    
}
