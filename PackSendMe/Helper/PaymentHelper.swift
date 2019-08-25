//
//  PaymentHelper.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

class PaymentHelper: NSObject {

    func makePaymentAccount(paymentAccountArray:[String:Any]) -> [(String,Array<PaymentMethodAccountDto>)] {
        let paymentArray = paymentAccountArray["payment"] as? [[String:Any]]
        var paymentFullCollection = [PaymentMethodAccountDto]()
        
        if(paymentArray != nil){
            for pay in paymentArray! {
                let payType = pay["payType"] as? String
               
                if payType == GlobalVariables.sharedManager.voucherPay{
                    let voucherPayTransaction = PaymentMethodAccountDto(
                        titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
                        payName: pay["payName"] as? String,
                        payCodenum: pay["payCodenum"] as? String,
                        payCountry : pay["payCountry"] as? String,
                        payEntity: pay["payEntity"] as? String,
                        payType: pay["payType"] as? String,
                        payExpiry: pay["payExpiry"] as? String,
                        payStatus: pay["payStatus"] as? String,
                        payValue: pay["payValue"] as? String,
                        dateCreation: pay["dateCreation"] as? String,
                        dateUpdate: pay["dateUpdate"] as? String)
                    paymentFullCollection.append(voucherPayTransaction)
                }
                else if payType == GlobalVariables.sharedManager.cardPay{
                    let cardPayTransaction = PaymentMethodAccountDto(
                        titleHead: NSLocalizedString("payment-title-card", comment:""),
                        payName: pay["payName"] as? String,
                        payCodenum: pay["payCodenum"] as? String,
                        payCountry : pay["payCountry"] as? String,
                        payEntity: pay["payEntity"] as? String,
                        payType: pay["payType"] as? String,
                        payExpiry: pay["payExpiry"] as? String,
                        payStatus: pay["payStatus"] as? String,
                        payValue: pay["payValue"] as? String,
                        dateCreation: pay["dateCreation"] as? String,
                        dateUpdate: pay["dateUpdate"] as? String
                    )
                    paymentFullCollection.append(cardPayTransaction)
                }
                else if payType == GlobalVariables.sharedManager.promotionPay{
                    let promotionPayTransaction = PaymentMethodAccountDto(
                        titleHead: NSLocalizedString("payment-title-promotions", comment:""),
                        payName: pay["payName"] as? String,
                        payCodenum: pay["payCodenum"] as? String,
                        payCountry : pay["payCountry"] as? String,
                        payEntity: pay["payEntity"] as? String,
                        payType: pay["payType"] as? String,
                        payExpiry: pay["payExpiry"] as? String,
                        payStatus: pay["payStatus"] as? String,
                        payValue: pay["payValue"] as? String,
                        dateCreation: pay["dateCreation"] as? String,
                        dateUpdate: pay["dateUpdate"] as? String
                    )
                    paymentFullCollection.append(promotionPayTransaction)
                }
            }
        }
        // ADD IN MENU THE ADD OPERATION (CARD/VOUCHER/PROMOTION)
        
        // VOUCHER
        let voucherPayTransaction = PaymentMethodAccountDto(
            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
            payName: NSLocalizedString("payment-title-addvouchers", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: "OperationMenu",
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateCreation: nil,
            dateUpdate: nil)
        paymentFullCollection.append(voucherPayTransaction)
        
        // CARD
        let cardPayTransaction = PaymentMethodAccountDto(
            titleHead: NSLocalizedString("payment-title-card", comment:""),
            payName: NSLocalizedString("payment-title-addcard", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: "OperationMenu",
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateCreation: nil,
            dateUpdate: nil)
        paymentFullCollection.append(cardPayTransaction)
        
        // PROMOTIONS
        let promotionPayTransaction = PaymentMethodAccountDto(
            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
            payName: NSLocalizedString("payment-title-addpromotions", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: "OperationMenu",
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateCreation: nil,
            dateUpdate: nil)
        paymentFullCollection.append(promotionPayTransaction)
        return parseFromJSONToPayment(payTransactions:paymentFullCollection)
     }
    
    private func parseFromJSONToPayment(payTransactions: [PaymentMethodAccountDto]) -> [(String,Array<PaymentMethodAccountDto>)] {
       var paymentAccounttransactions = Dictionary<String,Array<PaymentMethodAccountDto>>()
       for transaction in payTransactions {
            let title = transaction.titleHead
            if paymentAccounttransactions[title!] == nil {
                paymentAccounttransactions[title!] = Array<PaymentMethodAccountDto>()
            }
            paymentAccounttransactions[title!]?.append(transaction)
        }
        return paymentAccounttransactions.sorted { $0.0 < $1.0 }
    }
}
