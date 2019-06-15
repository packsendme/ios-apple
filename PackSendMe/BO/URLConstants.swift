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
        static let photoUI = "PhotoUI"
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
    
    struct ACCOUNT{
        static let account_http = "http://192.241.133.13:9094/account/"
        static let account_load = "/load"
        static let account_setting = "MenuAccountSetting"
        
        
        // All View To AccounthoME
        static let allViewToAccountHomeView = "AllViewToAccountHomeView"
        
        // SettingProfileUser = PhotoUser
        static let settingProfileUserViewToPhotoUserView = "SettingProfileUserViewToPhotoUserView"
        static let photoUserViewToSettingProfileUserView = "PhotoUserViewToSettingProfileUserView"
        
        
        // SettingProfileUser - SettingDataAccount | SettingDataAccount - SettingProfileUser
        static let settingProfileUserViewToSettingDataAccountView = "SettingProfileUserViewToSettingDataAccountView"


        static let settingViewToManagerPaymentView = "SettingViewToManagerPaymentView"
        
        // SettingProfileUser - ManagerProfile
        static let settingProfileUserViewControllerToManagerProfileNameView = "SettingProfileUserViewControllerToManagerProfileName"
        static let settingProfileUserViewControllerToManagerProfileEmailView = "SettingProfileUserViewControllerToManagerProfileEmailView"
        static let settingProfileUserViewControllerToManagerProfilePasswordView = "SettingProfileUserViewControllerToManagerProfilePasswordView"
        static let settingProfileUserViewControllerToManagerProfileUsernameView = "SettingProfileUserViewControllerToManagerProfileUsernameView"
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

