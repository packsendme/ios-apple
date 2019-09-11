//
//   URLServiceConstants.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 19/10/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

struct URLConstants{
    
    struct googleMaps{
        static let trackingID = "AIzaSyDt5pgW0boE_KhyVZHpNAh-o7Z0dQWt2IA"
        static let APIPlaces_TrackingID = "AIzaSyBYAqvauHBJyWYokwSb-sXrHD7HUAqVsq8"
   
    }

    struct IAM{
        static let iamIdentity_http = "http://192.241.133.13:9093/iam/identity/"
        static let iamAccess_http = "http://192.241.133.13:9093/iam/access/"
        static let iamManager_http = "http://192.241.133.13:9093/iam/manager/"

        static let smscode_register = "SMSCodeRegister"
        static let smscode_new = "SMSCodeNew"
        static let emailUI = "EmailUI"
        static let passwordUI = "PasswordUI"
        static let nameUI = "NameUI"
        static let usernameUI = "UsernameUI"
        static let country_identity = "countryIdentity"
        
        // Manager Access User (firstName / LastName / email / password / username)
        static let managerAccessViewToFirstNameView = "firstNameView"
        static let managerAccessViewToLastNameView = "lastNameView"
        static let managerAccessViewToEmailView = "emailView"
        static let managerAccessViewToPasswordView = "passwordView"
        static let managerAccessViewToUsernameView = "usernameView"
        
        // Manager Address User (address home / address work)
        
        // Manager Payment User (payment master / payment secund)
        

    }
    struct PAYMENT{
        static let payment_http = "http://192.241.133.13:9095/payment/"
        static let pay_validatecard = "http://192.241.133.13:9095/payment/card/validate/"
        static let payment_method = "http://192.241.133.13:9095/payment/method/"
     }
    
    struct COUNTRY{
        static let country_http = "http://192.241.133.13:9096/country/"
    }
    
    struct ACCOUNT{
        static let account_http = "http://192.241.133.13:9094/account/"
        static let accountpayment_http = "http://192.241.133.13:9094/account/payment/"

        static let account_load = "/load"
        // All View To AccounthoME
        static let allViewToAccountHomeView = "AllViewToAccountHomeView"
        static let settingViewToManagerPaymentView = "SettingViewToManagerPaymentView"
        
      
    }
    
    struct HTTP_STATUS{
        static let statusUsernameRegister = "USERNAME_REGISTER"
        static let statusUsernameFound = "FOUND_USER"
        static let statusSMSCodeFound = "SMSCODE_FOUND"
        static let statusSMSCodeNotFound = "SMSCODE_NOTFOUND"
        
        static let statusInternalServerError = "FAIL_EXECUTION"
    }
    
    struct HTTP_STATUS_CODE{
        static let OK = 200
        static let ACCEPT = 202
        static let NOTFOUND = 404
        static let FOUND = 302
        static let FAIL = 500
    }
    

}

