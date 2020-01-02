//
//  UserModel.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

public struct UserBO{

    var username: String?
    var password: String?
    var firstname: String?
    var lastname: String?
    var activated: Bool?
    var activationKey: String?
    var resetPasswordKey: Bool?
    var responseStatus: HttpResponseModel?
    var dateOperation: String?
    
    init(){
    }
    
    init(username:String, firstname:String, lastname:String, activated:Bool) {
        self.username = username
        self.firstname = firstname
        self.lastname = lastname
        self.activated = activated
    }
    
    
    func createUserArray(username:String, password:String, activated:String, activationKey:String, resetPasswordKey:String, dateOperation:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["password"] = password
        paramsDictionary["activated"] = activated
        paramsDictionary["activationKey"] = activationKey
        paramsDictionary["resetPasswordKey"] = resetPasswordKey
        paramsDictionary["dateOperation"] = dateOperation
        return paramsDictionary
    }

    func generatorUserAccessJson(json:[String:  Any]) -> UserBO {
        let json = json["body"] as! [String:Any]
        let userAccessObj = UserBO (username: json["username"] as! String, firstname: json["firstName"] as! String, lastname: json["lastName"] as! String, activated: json["activated"] as! Bool)
        return userAccessObj
    }

}
