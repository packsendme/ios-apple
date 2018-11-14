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

    struct IAM{
        static let iamIdentity_http = "http://192.241.133.13:9093/iam/identity/"
        static let iamAccess_http = "http://192.241.133.13:9093/iam/access/"
        static let iamManager_http = "http://192.241.133.13:9093/iam/manager/"

        static let email_register = "EmailRegisterUI"
        static let password_register = "PasswordRegisterUI"
        static let name_register = "NameRegisterUI"

    }
    
    struct ACCOUNT{
        static let account_http = "http://192.241.133.13:9094/account"

    }
    
    struct HTTP_STATUS{
        static let statusUsernameRegister = "USERNAME_REGISTER"
        static let statusUsernameFound = "FOUND_USER"
        static let statusSMSCodeFound = "SMSCODE_FOUND"
        static let statusSMSCodeNotFound = "SMSCODE_NOTFOUND"
        
        static let statusInternalServerError = "FAIL_EXECUTION"
    }
    
    struct HTTP_STATUS_CODE{
        static let ACCEPT = 202
        static let NOTFOUND = 404
        static let FOUND = 302
        static let FAIL = 500
    }
    

}

