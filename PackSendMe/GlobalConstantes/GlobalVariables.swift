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
    public var op_save : String = "SAVE-OP"
    public var op_edit : String = "EDIT-OP"
    
    // ValidationCard
    public var VALIDATE_CARD_SUCCESS : Int = 305
    public var VALIDATE_CARD_ERROR : Int = 409
    

    
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
    public var nameFirst: String = ""
    public var nameLast: String = ""
    public var profileImageDefault: String = "icon-user-photo"

    // Payment
    public var cardPay: String = "CARD_PAY"
    public var voucherPay: String = "VOUCHER_PAY"
    public var promotionPay: String = "PROMOTION_PAY"
    
    public var validateCard: String = "Validation-Card"
    public var InvalidCard: String = "Invalid-Card"
    
    // Operation
    public var OP_CHANGE_COUNTRY_NUMBER: String = "ManagerUsernamePhoneViewController"
    public var OP_CHANGE_COUNTRY_CARDPAY: String = "CardPaymentViewController"
    


    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    } 
}
