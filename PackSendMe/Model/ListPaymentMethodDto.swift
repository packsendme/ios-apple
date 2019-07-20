//
//  ListPaymentMethodDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 24/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class ListPaymentMethodDto: NSObject {
    var paymentmethod = [PaymentMethodModel]()
    
    override init() {
    }
    
    
    init(json: [String: Any]) {
        let payArray = json["payment"] as! [String:Any]
        
        for 
        //let payArray = paybodyArray //paybodyArray["payment"] as? [PaymentMethodModel]

        print(" 000000 loadPaymentMethod paramsDictionary : \(paybodyArray)")

        print(" 22222222 : \(payArray.count)")
        
 

       // for paymentMethod in payArray{
         
            //let name = paymentMethod.namePayMethod
        
        //}
        
        
        //print(" 33333 : \(payArray[0].namePayMethod)")

        
        print(" 555555 : \(paymentmethod.count)")

        
       // print(" 11111 loadPaymentMethod paramsDictionary : \(String(describing: payArray[1].namePayMethod))")
        
       // print(" 111111 loadPaymentMethod paramsDictionary : \(payArray![1].namePayMethod)")
      //  self.paymentmethod? = payArray! //paybodyArray as? [PaymentMethodModel]
        
        //print(" 2222 loadPaymentMethod paramsDictionary : \(self.paymentmethod)")

    }
}
