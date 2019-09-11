//
//  CardPayService.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 28/08/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import UIKit

class PaymentService: NSObject {
    
    var paymentAccountObj = PaymentAccountDto()
    
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
    
   // func findCountryAll(completion: @escaping (Bool, Any?, Error?) -> Void){
        
        
    func postPaymentMethod(paymentDto : PaymentAccountDto, completion: @escaping (Bool, Any?, Error?) -> Void){
       // print(" DATE CURRENT \(cardPaymentDto.dateOperation!)")
        var paramsDictionary = [String:Any]()
        paramsDictionary = paymentAccountObj.createPaymentDictionary(
        payName:"", payCodenum:paymentDto.payCodenum!,payCountry:paymentDto.payCountry!, payEntity:paymentDto.payEntity!,
        payType:paymentDto.payType!, payExpiry:paymentDto.payExpiry!, payStatus:paymentDto.payStatus!,
        payValue:paymentDto.payValue!, dateOperation:paymentDto.dateOperation!)

        let payment_url = URLConstants.ACCOUNT.accountpayment_http+"/"+GlobalVariables.sharedManager.usernameNumberphone

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
           
            HttpClientApi.instance().makeAPIBodyCall(url: payment_url, params:paramsDictionary, method: .POST, success: { (data, response, error) in

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
    
    func getValidateCreditCard(paymentDto : PaymentAccountDto, completion: @escaping (Bool, Any?, Error?) -> Void){
        
        let paramsDictionary : String = paymentDto.payCodenum!+"/"+paymentDto.payCountry!+"/"+paymentDto.payEntity!+"/"+paymentDto.payValue!+"/"+paymentDto.payExpiry!
        let payment_url = URLConstants.PAYMENT.pay_validatecard

        print(" RESULT getValidateCreditCard \(payment_url) ")

        DispatchQueue.global().asyncAfter(deadline: .now() + 2 ){
            HttpClientApi.instance().makeAPICall(url: payment_url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
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
}
    

