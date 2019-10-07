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
    var activated: Bool?
    var activationKey: String?
    var resetPasswordKey: Bool?
    var responseStatus: HttpResponseModel?
    var dateOperation: String?
    
    func createUserArray(username:String, email:String, password:String, name:String, lastName:String, country:String,dateOperation:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["password"] = email
        paramsDictionary["activated"] = name
        paramsDictionary["activationKey"] = password
        paramsDictionary["resetPasswordKey"] = lastName
        paramsDictionary["dateOperation"] = dateOperation
        return paramsDictionary
    }
    
}
