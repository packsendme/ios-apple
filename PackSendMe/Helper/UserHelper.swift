//
//  UserHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 11/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class UserHelper: NSObject {

    func userTransformObject(username:String, password:String) -> Dictionary<String, Any> {
        
        var paramsDictionary = [String:Any]()
        
        paramsDictionary["username"] = username
        paramsDictionary["password"] = password
        return paramsDictionary
    }
    
    
}
