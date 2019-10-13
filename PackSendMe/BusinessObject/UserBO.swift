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
    
}
