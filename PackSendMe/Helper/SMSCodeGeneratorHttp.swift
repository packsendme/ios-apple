//
//  SMSCodeGeneratorHttp.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 25/11/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class SMSCodeGeneratorHttp {
    
    var dateFormat = UtilityHelper()
    
    
    func generatorSMSCode() -> Int{
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = GlobalVariables.sharedManager.username+"/"+dateNow
        let url = URLConstants.IAM.iamIdentity_http
        var code : Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            code = (response?.statusCode)!
            semaphore.signal()
        }, failure: { (data, response, error) in
             code = 0
            
        })
        semaphore.wait()
        return code
    }
}
