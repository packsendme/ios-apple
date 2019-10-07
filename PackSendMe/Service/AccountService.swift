//
//  AMService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 30/09/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

public struct AccountService{

    var dateFormat = UtilityHelper()
    var profileObj = ProfileBO()
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : getLoadNamesAccount()
    // SCREEEN : HomePackSendMe
    // ACTION :  LOAD
    // -------------------------------------------------------------------------------------
    func getLoadNamesAccount(completion: @escaping (Bool, Any?, Error?) -> Void){
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone
        let accountURL = URLConstants.ACCOUNT.accountpersonal_http
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: accountURL, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            let jsonPay = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            let jsonPayBody = jsonPay!["body"] as? [String:Any]
                            let namesL = self.profileObj.createAccountObject(jsonAccount:jsonPayBody!)
                            DispatchQueue.main.async {
                                completion(true,namesL,nil)
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
    // FUNCTION : getLoadAccount()
    // SCREEEN : AUSettingViewControlle
    // ACTION :  GET
    // -------------------------------------------------------------------------------------
    func getLoadAccountUser(completion: @escaping (Bool, Any?, Error?) -> Void){
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+URLConstants.ACCOUNT.account_load
        let accountURL = URLConstants.ACCOUNT.account_http
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: accountURL, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            let jsonAccountBody = json!["body"] as? [String:Any]
                            let accountJsonObj = self.profileObj.createAccountAddressObject(jsonAccount: jsonAccountBody!)
                            DispatchQueue.main.async {
                                completion(true,accountJsonObj,nil)
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
    // FUNCTION : updateProfileByUsername()
    // SCREEEN : AUPManagerViewControlle
    // ACTION :  UPDATE
    // -------------------------------------------------------------------------------------
    func updateUserProfile(profile : ProfileBO, completion: @escaping (Bool, Any?, Error?) -> Void){
 
        let dateUpdate = dateFormat.dateConvertToString()
        let accountURL = URLConstants.ACCOUNT.account_http

        var paramsDictionary = [String:Any]()
        paramsDictionary = profileObj.createAccountDictionary(
            username: profile.username!,
            email: profile.email!,
            password: profile.password!,
            name: profile.name!,
            lastName: profile.lastName!,
            country: profile.country!,
            dateOperation: dateUpdate)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPIBodyCall(url: accountURL, params:paramsDictionary, method: .PUT, success:
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
