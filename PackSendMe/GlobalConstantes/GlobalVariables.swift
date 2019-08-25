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
    
    public var activationKey: String = ""
    public var status: String = ""

    
    // Address
    public var addressTypeJob: String = "addressJob"
    public var addressTypeHome: String = "addressHome"
    public var addressMain: String = "main"
    public var addressSecond: String = "second"
    public var personalInformation: String = "personalInformation"
    public var addressInformation: String = "addressInformation"
    
    // Account
    public var profileImage: String = ""
    public var usernameNumberphone: String = ""
    public var nameFirstMenu: String = ""
    public var nameLastMenu: String = ""
    public var profileImageDefault: String = "icon-user-photo"

    // Payment
    public var cardPay: String = "CARD_PAY"
    public var voucherPay: String = "VOUCHER_PAY"
    public var promotionPay: String = "PROMOTION_PAY"
    



    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    } 
}