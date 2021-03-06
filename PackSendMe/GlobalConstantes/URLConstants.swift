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




    
    struct COUNTRY{
        static let country_http = "http://192.241.133.13:9096/country/"
    }
    
    struct SMS{
        static let smscode_http = "http://192.241.133.13:9097/sms/"
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

