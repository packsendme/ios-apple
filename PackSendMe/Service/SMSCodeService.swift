//
//  SMSCodeService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 31/10/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SMSCodeService: NSObject {
    
    var dateFormat = UtilityHelper()
    
    struct SMS{
        static let smscode_http = "http://192.241.133.13:9097/sms/"
    }
    
    // ------------------------------------------------------------------------------------------------------------
    // FUNCTION : getSMSCodeValidate()
    // SCREEEN : IdentitySMSViewController
    // ACTION :  Validate SMS CODE
    // -----------------------------------------------------------------------------------------------------------
    func getSMSCodeValidate(username : String, codeSMS : String,completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = username+"/"+codeSMS
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: SMS.smscode_http, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if data != nil {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            DispatchQueue.main.async {
                                completion(true,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            DispatchQueue.main.async {
                                completion(false,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                            DispatchQueue.main.async {
                                completion(false,nil,NSURLErrorCancelled as? Error)
                            }
                        }
                        
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(false,nil,error)
                        }
                    }
                }
            }, failure: {  (data, response, error) in
                DispatchQueue.main.async {
                    completion(false,nil,error)
                }
            })
        }
    }
    
    // ------------------------------------------------------------------------------------------------------------
    // FUNCTION : getNewSMS()
    // SCREEEN : IdentitySMSViewController
    // ACTION :  Validate SMS CODE
    // -----------------------------------------------------------------------------------------------------------
    func getNewSMS(username : String,completion: @escaping (Bool, Any?, Error?) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: SMS.smscode_http, params:username, method: .GET, success: { (data, response, error) in
                if data != nil {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.ACCEPT{
                            DispatchQueue.main.async {
                                completion(true,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            DispatchQueue.main.async {
                                completion(false,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FAIL{
                            DispatchQueue.main.async {
                                completion(false,nil,NSURLErrorCancelled as? Error)
                            }
                        }
                        
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(false,nil,error)
                        }
                    }
                }
            }, failure: {  (data, response, error) in
                DispatchQueue.main.async {
                    completion(false,nil,error)
                }
            })
        }
    }

  

}
