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
    public var countrySingla: String = ""
    public var activationKey: String = ""
    public var status: String = ""

    // Transaction CRUD

    
    // ValidationCard
    public var VALIDATE_CARD_SUCCESS : Int = 305
    public var VALIDATE_CARD_ERROR : Int = 409
    

    
    // Address


    public var personalInformation: String = "personalInformation"
    public var addressInformation: String = "addressInformation"
    
    // Account
    public var profileImage: String = ""
    public var usernameNumberphone: String = ""
    public var nameFirst: String = ""
    public var nameLast: String = ""

    
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    } 
}
