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
    var activated: Bool?
    var activationKey: String?
    var password: String?
    var resetPasswordKey: Bool?
    var responseStatus: HttpResponseModel?

    init() {
        
    }
  
    init(json: [String: Any]) {
        self.username = json["username"] as? String ?? ""
        self.id = json["id"] as? String ?? ""
        self.activationKey = json["activationKey"] as? String ?? ""
        self.password = json["password"] as? String ?? ""
        self.activated = json["activated"] as? Bool ?? false
        self.resetPasswordKey = json["resetPasswordKey"] as? Bool ?? false
    }
    
     /*
    init(id:String, username:String, activated:String, activationKey:String,password:String,resetPasswordKey:String) {
        self.id = id
        self.username = username
        self.activated = activated
        self.activationKey = activationKey
        self.password = password
        self.resetPasswordKey = resetPasswordKey
    }*/
    
    
    
}
