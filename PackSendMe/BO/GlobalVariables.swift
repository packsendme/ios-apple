//
//  GlobalVariables.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 12/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class GlobalVariables {

    // Country
    public var countryNameInstance: String = ""
    var countryImageInstance: UIImage? = nil
    public var countryCodInstance: String = ""
    public var countryFormatInstance: String = ""
    public var username: String = ""
    public var usernameChange: String = ""
    public var nameFirst: String = ""
    public var nameLast: String = ""
    public var activationKey: String = ""
    public var status: String = ""
    public var profileImage: String = ""
    public var profileImageDefault: String = "icon-user-photo"
    public var addressTypeJob: String = "addressJob"
    public var addressTypeHome: String = "addressHome"
    public var addressMain: String = "main"
    public var addressSecond: String = "second"

    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    } 
}
