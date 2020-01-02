//
//  PaymentAllDto.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 06/07/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation

public struct PaymentAccountBO: Codable {
    var titleHead: String?
    var payName: String?
    var payCodenum: String?
    var payCountry: String?
    var payEntity: String?
    var payType: String?
    var payExpiry: String?
    var payStatus: String?
    var payValue: String?
    var dateOperation: String?
    var operationTransaction: String?


    /*
    init(json: [String: Any]) {
        self.titleHead = json["titleHead"] as? String ?? ""
        self.usernamephnumber = json["usernamephnumber"] as? String ?? ""
        self.payName = json["payName"] as? String ?? ""
        self.payCodenum = json["payCodenum"] as? String ?? ""
        self.payCountry = json["payCountry"] as? String ?? ""
        self.payEntity = json["payEntity"] as? String ?? ""
        self.payType = json["payType"] as? String ?? ""
        self.payExpiry = json["payExpiry"] as? String ?? ""
        self.payStatus = json["payStatus"] as? String ?? ""
        self.payValue = json["payValue"] as? String ?? ""
        self.dateOperation = json["dateOperation"] as? String ?? ""
    }
     
     paymentAccountObj.createPaymentDictionary(usernamephnumber:GlobalVariables.sharedManager.usernameNumberphone, payName:"", payCodenum:cardPaymentDto.payCodenum!, payCountry:cardPaymentDto.payCountry!, payEntity:cardPaymentDto.payEntity!, payType:cardPaymentDto.payType!, payExpiry:cardPaymentDto.payExpiry!, payStatus:cardPaymentDto.payStatus!, payValue:cardPaymentDto.payValue!, dateOperation:cardPaymentDto.dateOperation!)
     
     
    */
    func createPaymentDictionary(payName:String, payCodenum:String, payCountry:String, payEntity:String, payType:String, payExpiry:String, payStatus:String, payValue:String, dateOperation:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["payName"] = payName
        paramsDictionary["payCodenum"] = payCodenum
        paramsDictionary["payCountry"] = payCountry
        paramsDictionary["payEntity"] = payEntity
        paramsDictionary["payType"] = payType
        paramsDictionary["payExpiry"] = payExpiry
        paramsDictionary["payStatus"] = payStatus
        paramsDictionary["payValue"] = payValue
        paramsDictionary["dateOperation"] = dateOperation
        return paramsDictionary
    }
    
    func createDictionaryToValidateCard(payCodenum:String, payCountry:String, payEntity:String, payExpiry:String, payValue:String) -> Dictionary<String, Any> {
        var paramsDictionary = [String:Any]()
        paramsDictionary["payCodenum"] = payCodenum
        paramsDictionary["payCountry"] = payCountry
        paramsDictionary["payEntity"] = payEntity
        paramsDictionary["payExpiry"] = payExpiry
        paramsDictionary["payValue"] = payValue
        return paramsDictionary
    }
    
    func generateObjJsonPayAccount(paymentAccountArray:[String:Any]) -> [(String,Array<PaymentAccountBO>)] {
        var paymentFullCollection = [PaymentAccountBO]()
        if paymentAccountArray.isEmpty == false{
            let paymentArray = paymentAccountArray["payment"] as? [[String:Any]]
            if(paymentArray != nil){
                for pay in paymentArray! {
                    let payType = pay["payType"] as? String
                    if payType == GPConstants.voucherPay.rawValue{
                        let voucherPayTransaction = PaymentAccountBO(
                            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
                            payName: pay["payName"] as? String,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateOperation"] as? String,
                            operationTransaction: GPConstants.op_edit.rawValue)
                        paymentFullCollection.append(voucherPayTransaction)
                    }
                    else if payType == GPConstants.cardPay.rawValue{
                        let cardPayTransaction = PaymentAccountBO(
                            titleHead: NSLocalizedString("payment-title-card", comment:""),
                            payName: nil,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateOperation"] as? String,
                            operationTransaction: GPConstants.op_edit.rawValue)
                        paymentFullCollection.append(cardPayTransaction)
                    }
                    else if payType == GPConstants.promotionPay.rawValue{
                        let promotionPayTransaction = PaymentAccountBO(
                            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
                            payName: pay["payName"] as? String,
                            payCodenum: pay["payCodenum"] as? String,
                            payCountry : pay["payCountry"] as? String,
                            payEntity: pay["payEntity"] as? String,
                            payType: pay["payType"] as? String,
                            payExpiry: pay["payExpiry"] as? String,
                            payStatus: pay["payStatus"] as? String,
                            payValue: pay["payValue"] as? String,
                            dateOperation: pay["dateUpdate"] as? String,
                            operationTransaction: GPConstants.op_edit.rawValue)
                        paymentFullCollection.append(promotionPayTransaction)
                    }
                }
                
            }
        }
        // ADD IN MENU THE ADD OPERATION (CARD/VOUCHER/PROMOTION)
        
        // VOUCHER
        let voucherPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
            payName: NSLocalizedString("payment-title-addvouchers", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.voucherPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(voucherPayTransaction)
        
        // CARD
        let cardPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-card", comment:""),
            payName: NSLocalizedString("payment-title-addcard", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.cardPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(cardPayTransaction)
        
        // PROMOTIONS
        let promotionPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
            payName: NSLocalizedString("payment-title-addpromotions", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.promotionPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(promotionPayTransaction)
        return parseFromJSONToPayment(payTransactions:paymentFullCollection)
    }
    
    
    func generateObjJsonPayAccountNull() -> [(String,Array<PaymentAccountBO>)] {
        var paymentFullCollection = [PaymentAccountBO]()
        
        // ADD IN MENU THE ADD OPERATION (CARD/VOUCHER/PROMOTION)
        
        // VOUCHER
        let voucherPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-vouchers", comment:""),
            payName: NSLocalizedString("payment-title-addvouchers", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.voucherPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(voucherPayTransaction)
        
        // CARD
        let cardPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-card", comment:""),
            payName: NSLocalizedString("payment-title-addcard", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.cardPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(cardPayTransaction)
        
        // PROMOTIONS
        let promotionPayTransaction = PaymentAccountBO(
            titleHead: NSLocalizedString("payment-title-promotions", comment:""),
            payName: NSLocalizedString("payment-title-addpromotions", comment:""),
            payCodenum: nil,
            payCountry : nil,
            payEntity: nil,
            payType: GPConstants.promotionPay.rawValue,
            payExpiry: nil,
            payStatus: nil,
            payValue: nil,
            dateOperation: nil,
            operationTransaction: GPConstants.op_save.rawValue)
        paymentFullCollection.append(promotionPayTransaction)
        return parseFromJSONToPayment(payTransactions:paymentFullCollection)
    }
    
    private func parseFromJSONToPayment(payTransactions: [PaymentAccountBO]) -> [(String,Array<PaymentAccountBO>)] {
        var paymentAccounttransactions = Dictionary<String,Array<PaymentAccountBO>>()
        for transaction in payTransactions {
            let title = transaction.titleHead
            if paymentAccounttransactions[title!] == nil {
                paymentAccounttransactions[title!] = Array<PaymentAccountBO>()
            }
            paymentAccounttransactions[title!]?.append(transaction)
        }
        return paymentAccounttransactions.sorted { $0.0 < $1.0 }
    }
   
}
