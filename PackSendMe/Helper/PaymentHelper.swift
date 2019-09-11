//
//  PaymentHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class PaymentHelper: NSObject {

    func generateObjJsonPayAccount(paymentAccountArray:[String:Any]) -> [(String,Array<PaymentAccountDto>)] {
        var paymentFullCollection = [PaymentAccountDto]()
        if paymentAccountArray.isEmpty == false{
            let paymentArray = paymentAccountArray["payment"] as? [[String:Any]]
            if(paymentArray != nil){
                for pay in paymentArray! {
                    let payType = pay["payType"] as? String
                    if payType == GlobalVariables.sharedManager.voucherPay{
                        let voucherPayTransaction = PaymentAccountDto(
                            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
                            payName: pay["payName"] as? String,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateOperation"] as? String)
                        paymentFullCollection.append(voucherPayTransaction)
                    }
                    else if payType == GlobalVariables.sharedManager.cardPay{
                        let cardPayTransaction = PaymentAccountDto(
                            titleHead: NSLocalizedString("payment-title-card", comment:""),
                            payName: nil,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateOperation"] as? String
                        )
                        paymentFullCollection.append(cardPayTransaction)
                    }
                    else if payType == GlobalVariables.sharedManager.promotionPay{
                        let promotionPayTransaction = PaymentAccountDto(
                            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
                            payName: pay["payName"] as? String,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateUpdate"] as? String
                        )
                        paymentFullCollection.append(promotionPayTransaction)
                    }
                }
            }
        }
        // ADD IN MENU THE ADD OPERATION (CARD/VOUCHER/PROMOTION)
        
        // VOUCHER
        let voucherPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
            payName: NSLocalizedString("payment-title-addvouchers", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.voucherPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(voucherPayTransaction)
        
        // CARD
        let cardPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-card", comment:""),
            payName: NSLocalizedString("payment-title-addcard", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.cardPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(cardPayTransaction)
        
        // PROMOTIONS
        let promotionPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
            payName: NSLocalizedString("payment-title-addpromotions", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.promotionPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(promotionPayTransaction)
        return parseFromJSONToPayment(payTransactions:paymentFullCollection)
     }
    
    
    func generateObjJsonPayAccountNull() -> [(String,Array<PaymentAccountDto>)] {
        var paymentFullCollection = [PaymentAccountDto]()
        
        // ADD IN MENU THE ADD OPERATION (CARD/VOUCHER/PROMOTION)
        
        // VOUCHER
        let voucherPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
            payName: NSLocalizedString("payment-title-addvouchers", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.voucherPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(voucherPayTransaction)
        
        // CARD
        let cardPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-card", comment:""),
            payName: NSLocalizedString("payment-title-addcard", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.cardPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(cardPayTransaction)
        
        // PROMOTIONS
        let promotionPayTransaction = PaymentAccountDto(
            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
            payName: NSLocalizedString("payment-title-addpromotions", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GlobalVariables.sharedManager.promotionPay,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil)
        paymentFullCollection.append(promotionPayTransaction)
        return parseFromJSONToPayment(payTransactions:paymentFullCollection)
    }
    
    private func parseFromJSONToPayment(payTransactions: [PaymentAccountDto]) -> [(String,Array<PaymentAccountDto>)] {
       var paymentAccounttransactions = Dictionary<String,Array<PaymentAccountDto>>()
       for transaction in payTransactions {
            let title = transaction.titleHead
            if paymentAccounttransactions[title!] == nil {
                paymentAccounttransactions[title!] = Array<PaymentAccountDto>()
            }
            paymentAccounttransactions[title!]?.append(transaction)
        }
        return paymentAccounttransactions.sorted { $0.0 < $1.0 }
    }
}
