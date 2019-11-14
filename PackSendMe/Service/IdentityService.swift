//
//  IAMService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 25/09/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class IdentityService: NSObject {
    
    var dateFormat = UtilityHelper()
    var profileObj = ProfileBO()
    var userObj = UserBO()
    
    struct url_IAM{
        static let iamIdentity_http = "http://192.241.133.13:9093/iam/identity/"
        static let iamAccess_http = "http://192.241.133.13:9093/iam/access/"
        static let iamManager_http = "http://192.241.133.13:9093/iam/manager/"
    }
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : getIdentityAuthentication()
    // SCREEEN : FirstScreen
    // ACTION :  Validate phoneNumber the register if no register will be generator SMS COde, if YES load Account
    // -------------------------------------------------------------------------------------
    
    func getIdentityAuthentication(username : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = username+"/"+dateNow
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: url_IAM.iamIdentity_http, params:paramsDictionary, method: .GET, success: { (data, response, error) in
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

    func getAccessManager(username : String,password : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        let paramsDictionary : String = username+"/"+password
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: url_IAM.iamAccess_http, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            DispatchQueue.main.async {
                                let jsonUser = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                                let useraccountObj = self.userObj.generatorUserAccessJson(json: jsonUser!)
                                completion(true,useraccountObj,nil)
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
    // FUNCTION : postCreateAccount()
    // SCREEEN : ManagerRegisterView (email / password / first/last/name)
    // ACTION :  REGISTER DATE ACCOUNT USER
    // -----------------------------------------------------------------------------------------------------------
    
    func postCreateAccount(account:ProfileBO,completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary = profileObj.createAccountDictionary(username:account.username!, email:account.email!, password:account.password!, name:account.name!, lastName:account.lastName!, country:account.country!,dateOperation:account.dateOperation!)
        
        let accountURL =  AccountService.url_account.account_http
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPIBodyCall(url: accountURL, params:paramsDictionary, method: .POST, success: { (data, response, error) in
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
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+password
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: url_IAM.iamAccess_http, params:paramsDictionary, method: .GET, success: { (data, response, error) in
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPIBodyCall(url: url_IAM.iamManager_http, params:paramsDictionary, method: .PUT, success:
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
    
    // ------------------------------------------------------------------------------------------------------------
    // FUNCTION : putValidateSMSUpdateUsername()
    // SCREEEN : SecundScreen - IdentitySMSViewController
    // ACTION :  GENERATOR SMS
    // -----------------------------------------------------------------------------------------------------------
    func putUsernamePhone(usernameNew : String, codeSMS : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let dateNow = dateFormat.dateConvertToString()
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+usernameNew+"/"+codeSMS+"/"+dateNow

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: url_IAM.iamManager_http, params:paramsDictionary, method: .PUT, success: { (data, response, error) in
                if data != nil {
                    do{
                        print(" putValidateSMSUpdateUsername  RESULT >> \(response?.statusCode) ")
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            DispatchQueue.main.async {
                                completion(true,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            DispatchQueue.main.async {
                                completion(false,response?.statusCode,NSURLErrorCancelled as? Error)
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
