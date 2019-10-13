//
//  IAMService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 25/09/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class IAService: NSObject {
    
    var dateFormat = UtilityHelper()
    var profileObj = ProfileBO()
    var userObj = UserBO()
    
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : getIdentityAuthentication()
    // SCREEEN : FirstScreen
    // ACTION :  Validate phoneNumber the register if no register will be generator SMS COde, if YES load Account
    // -------------------------------------------------------------------------------------
    
    func getIdentityAuthentication(completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+dateNow

        print(" NEW getIdentityAuthentication RESULT \(paramsDictionary)")

        let loginURL = URLConstants.IAM.iamIdentity_http
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: loginURL, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK ||
                            response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            
                            DispatchQueue.main.async {
                                completion(true,response?.statusCode,nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                completion(false,nil,nil)
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

    
    // -------------------------------------------------------------------------------------
    // FUNCTION : getAccessManager()
    // SCREEEN : SecundScreen - Input Password
    // ACTION :  Validate password to access account
    // -------------------------------------------------------------------------------------

    func getAccessManager(password : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+password
        GlobalVariables.sharedManager.profileImage = "imageProfile_"+GlobalVariables.sharedManager.usernameNumberphone
        
        let loginURL = URLConstants.IAM.iamAccess_http
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: loginURL, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            DispatchQueue.main.async {
                                    completion(true,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            DispatchQueue.main.async {
                                completion(false,nil,nil)
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
    // FUNCTION : getSMSCodeValidate()
    // SCREEEN : IdentitySMSViewController
    // ACTION :  Validate SMS CODE
    // -----------------------------------------------------------------------------------------------------------
    func getSMSCodeValidate(codeSMS1 : String, codeSMS2 : String, codeSMS3 : String, codeSMS4 : String,completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+codeSMS1+codeSMS2+codeSMS3+codeSMS4
        let urlSMS = URLConstants.IAM.iamIdentity_http+"sms/"
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: urlSMS, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if data != nil {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
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
    // FUNCTION : getGeneratorSMSCode()
    // SCREEEN : SecundScreen - IdentitySMSViewController
    // ACTION :  GENERATOR SMS
    // -----------------------------------------------------------------------------------------------------------
    func generatorSMSCode() -> Int{
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+dateNow
        let url = URLConstants.IAM.iamIdentity_http
        var code : Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        
        HttpService.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            code = (response?.statusCode)!
            semaphore.signal()
        }, failure: { (data, response, error) in
            code = 0
            
        })
        semaphore.wait()
        return code
    }

    // ------------------------------------------------------------------------------------------------------------
    // FUNCTION : postCreateAccount()
    // SCREEEN : ManagerRegisterView (email / password / first/last/name)
    // ACTION :  REGISTER DATE ACCOUNT USER
    // -----------------------------------------------------------------------------------------------------------
    
    func postCreateAccount(account:ProfileBO,completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary = profileObj.createAccountDictionary(username:account.username!, email:account.email!, password:account.password!, name:account.name!, lastName:account.lastName!, country:account.country!,dateOperation:account.dateOperation!)
        
        let accountURL = URLConstants.ACCOUNT.account_http
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPIBodyCall(url: accountURL, params:paramsDictionary, method: .POST, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.ACCEPT{
                            DispatchQueue.main.async {
                                completion(true,nil,nil)
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
    // FUNCTION : getPasswordCurrent
    // SCREEEN : AUPManager ( Change Password)
    // ACTION :  GET (RETURN FOUND or NOTFOUND )
    // -----------------------------------------------------------------------------------------------------------
    func getPasswordCurrent(password : String,completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let iamURL = URLConstants.IAM.iamAccess_http
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+password

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: iamURL, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
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
            }, failure: {  (data, response, error) in
                DispatchQueue.main.async {
                    completion(false,nil,error)
                }
            })
        }
    }
    
    
    
    
    // ------------------------------------------------------------------------------------------------------------
    // FUNCTION : putPassword
    // SCREEEN : AUPManager ( Change Password)
    // ACTION :  PUT (RETURN OK or ERROR )
    // Entity : UserBO
    // -----------------------------------------------------------------------------------------------------------
    func updatePassword(password : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let dateUpdate = dateFormat.dateConvertToString()
        let paramsDictionary = userObj.createUserArray(username:GlobalVariables.sharedManager.usernameNumberphone, password:password, activated:"", activationKey:"", resetPasswordKey:"", dateOperation:dateUpdate)
        
        let iamURL = URLConstants.IAM.iamManager_http

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPIBodyCall(url: iamURL, params:paramsDictionary, method: .PUT, success:
                { (data, response, error) in
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            DispatchQueue.main.async {
                                completion(true,nil,nil)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                completion(false,nil,nil)
                            }
                        }
                    } catch _ {
                        DispatchQueue.main.async {
                            completion(false,nil,error)
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
