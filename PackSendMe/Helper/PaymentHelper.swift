//
//  PaymentHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class PaymentHelper: NSObject {

    func parseFromJSONToCardPayment(paymentAccountArray:[String:Any]) -> [PaymentAllDto] {
        let accountArray = paymentAccountArray["body"] as! [String:Any]
        let cardArray = accountArray["card"] as? [[String:Any]]
        var payAll = PaymentAllDto()
        var paymentCollection = [PaymentAllDto]()
        
        if(cardArray != nil){
            for card in cardArray! {
                if let cardName = card["cardName"] as? String {
                    payAll.desc1 = cardName
                }
                if let cardNumber = card["cardNumber"] as? String {
                    payAll.desc2 = cardNumber
                }
                if let cardExpiry = card["cardExpiry"] as? String {
                    payAll.desc3 = cardExpiry
                }
                if let cardCVV = card["cardCVV"] as? String {
                    payAll.desc4 = cardCVV
                }
                if let cardType = card["cardType"] as? String {
                    payAll.desc5 = cardType
                }
                paymentCollection.append(payAll)
                payAll = PaymentAllDto()
            }
        }
        return paymentCollection
    }
    
    func parseFromJSONToVoucherPayment(paymentAccountArray:[String:Any]) -> [PaymentAllDto] {
        let accountArray = paymentAccountArray["body"] as! [String:Any]
        let voucherArray = accountArray["voucher"] as? [[String:Any]]
        var payAll = PaymentAllDto()
        var paymentCollection = [PaymentAllDto]()
        
        if(voucherArray != nil){
            for voucher in voucherArray! {
                if let voucherName = voucher["voucherName"] as? String {
                    payAll.desc1 = voucherName
                }
                if let voucherCode = voucher["voucherCode"] as? String {
                    payAll.desc2 = voucherCode
                }
                if let voucherBenefits = voucher["voucherBenefits"] as? String {
                    payAll.desc3 = voucherBenefits
                }
                if let voucherValue = voucher["voucherValue"] as? String {
                    payAll.desc4 = voucherValue
                }
                if let voucherStatus = voucher["voucherStatus"] as? String {
                    payAll.desc5 = voucherStatus
                }
                paymentCollection.append(payAll)
                payAll = PaymentAllDto()
            }
        }
        return paymentCollection
    }
    
    func parseFromJSONToPromotionPayment(paymentAccountArray:[String:Any]) -> [PaymentAllDto] {
        let accountArray = paymentAccountArray["body"] as! [String:Any]
        let promotionArray = accountArray["promotion"] as? [[String:Any]]
        var payAll = PaymentAllDto()
        var paymentCollection = [PaymentAllDto]()
        
        if(promotionArray != nil){
            for promotion in promotionArray! {
                if let promotionName = promotion["promotionName"] as? String {
                    payAll.desc1 = promotionName
                }
                if let promotionCode = promotion["promotionCode"] as? String {
                    payAll.desc2 = promotionCode
                }
                if let promotionBenefits = promotion["promotionBenefits"] as? String {
                    payAll.desc3 = promotionBenefits
                }
                if let promotionValue = promotion["promotionValue"] as? String {
                    payAll.desc4 = promotionValue
                }
                if let promotionStatus = promotion["promotionStatus"] as? String {
                    payAll.desc5 = promotionStatus
                }
                paymentCollection.append(payAll)
                payAll = PaymentAllDto()
            }
        }
        return paymentCollection
    }


}
