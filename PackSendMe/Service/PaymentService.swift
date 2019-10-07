//
//  CardPayService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class PaymentService: NSObject {
    
    var paymentAccountObj = PaymentAccountBO()
    
    static func instance() ->  PaymentService{
        return PaymentService()
    }
    
    func validateCardType(testCard: String) -> String {
        
        let regVisa = "^4[0-9]{12}(?:[0-9]{3})?$"
        //let regMaster = "^5[1-5][0-9]{14}$"
        let regMaster = "^5[1-5][0-9]{14}$|^2(?:2(?:2[1-9]|[3-9][0-9])|[3-6][0-9][0-9]|7(?:[01][0-9]|20))[0-9]{12}$"
        let regExpress = "^3[47][0-9]{13}$"
        let regDiners = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        let regDiscover = "^6(?:011|5[0-9]{2})[0-9]{12}$"
        let regJCB = "^(?:2131|1800|35\\d{3})\\d{11}$"
        
        let regVisaTest = NSPredicate(format: "SELF MATCHES %@", regVisa)
        let regMasterTest = NSPredicate(format: "SELF MATCHES %@", regMaster)
        let regExpressTest = NSPredicate(format: "SELF MATCHES %@", regExpress)
        let regDinersTest = NSPredicate(format: "SELF MATCHES %@", regDiners)
        let regDiscoverTest = NSPredicate(format: "SELF MATCHES %@", regDiscover)
        let regJCBTest = NSPredicate(format: "SELF MATCHES %@", regJCB)
        
        
        if regVisaTest.evaluate(with: testCard){
            return "VisaCard"
        }
        else if regMasterTest.evaluate(with: testCard){
            return "MasterCard"
        }
            
        else if regExpressTest.evaluate(with: testCard){
            return "AmericanCard"
        }
            
        else if regDinersTest.evaluate(with: testCard){
            return "DinersCard"
        }
            
        else if regDiscoverTest.evaluate(with: testCard){
            return "DiscoverCard"
        }
            
        else if regJCBTest.evaluate(with: testCard){
            return "JCB"
        }
        return ""
    }
    
    func getPaymentsByUsername(completion: @escaping (Bool, Any?, Error?) -> Void){
        let payment_url = URLConstants.ACCOUNT.accountpayment_http
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: payment_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK {
                            let jsonPay = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            let jsonPayBody = jsonPay!["body"] as? [String:Any]
                            let paymentL = self.paymentAccountObj.generateObjJsonPayAccount(paymentAccountArray: jsonPayBody!)
                            DispatchQueue.main.async {
                                completion(true,paymentL,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            let paymentL = self.paymentAccountObj.generateObjJsonPayAccountNull()
                            DispatchQueue.main.async {
                                completion(true,paymentL,nil)
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
    
        
    func postPaymentMethod(paymentDto : PaymentAccountBO, completion: @escaping (Bool, Any?, Error?) -> Void){
        var paramsDictionary = [String:Any]()
        paramsDictionary = paymentAccountObj.createPaymentDictionary(
        payName:"", payCodenum:paymentDto.payCodenum!,payCountry:paymentDto.payCountry!, payEntity:paymentDto.payEntity!,
        payType:paymentDto.payType!, payExpiry:paymentDto.payExpiry!, payStatus:paymentDto.payStatus!,
        payValue:paymentDto.payValue!, dateOperation:paymentDto.dateOperation!)

        let payment_url = URLConstants.ACCOUNT.accountpayment_http+GlobalVariables.sharedManager.usernameNumberphone
         print(" RESULT postPaymentMethod \(payment_url)")

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
           
            HttpService.instance().makeAPIBodyCall(url: payment_url, params:paramsDictionary, method: .POST, success: { (data, response, error) in

                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            DispatchQueue.main.async {
                                completion(true,jsonCountry,nil)
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
    
    func getValidateCreditCard(paymentDto : PaymentAccountBO, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = paymentDto.payCodenum!+"/"+paymentDto.payCountry!+"/"+paymentDto.payEntity!+"/"+paymentDto.payValue!+"/"+paymentDto.payExpiry!
        let payment_url = URLConstants.PAYMENT.pay_validatecard

        print(" RESULT getValidateCreditCard \(payment_url) ")

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: payment_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                        let responseCode = jsonCountry!["responseCode"] as? Int
                        
                        print(" RESULT getValidateCreditCard \(responseCode) ")

                        
                        if responseCode == GlobalVariables.sharedManager.VALIDATE_CARD_SUCCESS{
                            print(" RESULT responseCode OK \(responseCode) ")

                            DispatchQueue.main.async {
                                completion(true,jsonCountry,nil)
                            }
                        }
                        else if responseCode == GlobalVariables.sharedManager.VALIDATE_CARD_ERROR{
                            print(" RESULT responseCode NOK \(responseCode) ")

                            DispatchQueue.main.async {
                                completion(false,nil,error)
                            }
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
    
    
    func putPaymentMethod(paymentDto : PaymentAccountBO, completion: @escaping (Bool, Any?, Error?) -> Void){
        var paramsDictionary = [String:Any]()
        paramsDictionary = paymentAccountObj.createPaymentDictionary(
            payName:"", payCodenum:paymentDto.payCodenum!,payCountry:paymentDto.payCountry!, payEntity:paymentDto.payEntity!,
            payType:paymentDto.payType!, payExpiry:paymentDto.payExpiry!, payStatus:paymentDto.payStatus!,
            payValue:paymentDto.payValue!, dateOperation:paymentDto.dateOperation!)
        
        let payment_url = URLConstants.ACCOUNT.accountpayment_http+GlobalVariables.sharedManager.usernameNumberphone+"/"+paymentDto.payCodenum!
        
        print(" RESULT updatePaymentMethod \(payment_url)")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            
            HttpService.instance().makeAPIBodyCall(url: payment_url, params:paramsDictionary, method: .PUT, success: { (data, response, error) in
                
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            DispatchQueue.main.async {
                                completion(true,jsonCountry,nil)
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
    
    
    func removePaymentMethod(paymentDto : PaymentAccountBO, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+paymentDto.payCodenum!+"/"+paymentDto.payType!
        
        let payment_url = URLConstants.ACCOUNT.accountpayment_http
        
        print(" RESULT removePaymentMethod \(payment_url)")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            
            HttpService.instance().makeAPICall(url: payment_url, params:paramsDictionary, method: .DELETE, success: { (data, response, error) in
                
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                            let jsonCountry = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                            DispatchQueue.main.async {
                                completion(true,jsonCountry,nil)
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
    
    func getPaymentByNumcod(codnum : String, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+codnum
        let payment_url = URLConstants.ACCOUNT.accountpayment_http
        print(" RESULT getPaymentByNumcod \(payment_url)")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpService.instance().makeAPICall(url: payment_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
                if let data = data {
                    do{
                        if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
                            print(" RESULT CODE getPaymentByNumcod \(response?.statusCode)")

                            DispatchQueue.main.async {
                                completion(false,nil,nil)
                            }
                        }
                        else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                            DispatchQueue.main.async {
                                print(" RESULT CODE getPaymentByNumcod \(response?.statusCode)")
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
}
    

