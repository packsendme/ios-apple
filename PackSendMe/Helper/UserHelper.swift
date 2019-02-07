//
//  UserHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 11/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class UserHelper: NSObject {

    func transformObjectToArray(username:String, password:String, dtAction:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["username"] = username
        paramsDictionary["password"] = password
        paramsDictionary["dtAction"] = dtAction
        return paramsDictionary
    }
 
    func transformArrayToUserModel(user:[String:Any]) -> UserModel {
        let userArray = user["body"] as! [String:Any]
        let user = UserModel(json: userArray)
        return user
    }

}
