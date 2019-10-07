//
//  EditPaymentUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SettingPaymentUserViewController: UIViewController {
    
    @IBOutlet weak var labelTitleScreenPay: UILabel!
    @IBOutlet weak var tablePayment: UITableView!
    var jsonAccountFinal : [String: Any]? = nil
    var paymentL = [(String,Array<PaymentAccountBO>)]()
    let paymentBO = PaymentAccountBO()
    var payTransactionSelect = PaymentAccountBO()

    var paymentService = PaymentService()
    
    @IBOutlet weak var paymentTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTitle.text = NSLocalizedString("payment-title-methodopay", comment:"")
        //self.tablePayment.rowHeight = UITableViewAutomaticDimension
        loadPaymentMethodAccount()
    }
    
    func loadPaymentMethodAccount(){
        paymentService.getPaymentsByUsername(){(success, response, error) in
            if success{
               self.paymentL = response as! [(String,Array<PaymentAccountBO>)]
                self.refreshTable()
            }
            else if error != nil{
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    
    }
        
    func refreshTable() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.tablePayment.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "VoucherPayOperationView"{

        }
        if segue.identifier == "CardPayOperationView"{
            print(" ----**************-------")
            let cardpayVC = segue.destination as? CardPaymentViewController
            cardpayVC?.cardpaySelect = payTransactionSelect
        }
        if segue.identifier == "PromotionPayOperationView"{
        
        }
    }
    
}

extension SettingPaymentUserViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print (" TOTAL numberOfRowsInSection  = \(self.paymentL[section].1.count)")
        return self.paymentL[section].1.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       //print (" TOTAL LINHA  = \(paymentL.count)")
        return paymentL.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return paymentL[section].0
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) //as? SettingViewCell

       guard let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentCell", for: indexPath) as? SettingViewCell
        else{
          return UITableViewCell()
        }

        cell.identificador1Label.font = UIFont(name:"Avenir", size:17)
        cell.identificador1Label.textColor = UIColor.darkGray
        tableView.rowHeight = 60
        let payTransaction = paymentL[indexPath.section].1[indexPath.row]
        
        // Add choose to Add Card or Voucher pay or find promotion
        if payTransaction.payName != nil {
            cell.identificador1Label.text = payTransaction.payName
            cell.identificador1Label.textColor = UIColor.blue
            cell.identificador3Label.isHidden = true
            cell.accessoryType = .none
        }
   
        if payTransaction.payCodenum != nil {
            let mySubstring = "•••• "+payTransaction.payCodenum!.suffix(3)
            cell.identificador1Label.text = String(mySubstring) as String
            cell.identificador3Label.isHidden = false
        }
        
        
        if payTransaction.payStatus == GlobalVariables.sharedManager.validateCard {
            cell.identificador3Label.textColor = UIColor.blue
            cell.identificador3Label.font = UIFont(name:"Avenir", size:16)
            cell.identificador3Label.text = NSLocalizedString("payment-title-statusvalidated", comment:"")
        }
        else if payTransaction.payStatus == GlobalVariables.sharedManager.InvalidCard {
            cell.identificador3Label.textColor = UIColor.red
            cell.identificador3Label.font = UIFont(name:"Avenir", size:16)
            cell.identificador3Label.text = NSLocalizedString("payment-title-statusinvalid", comment:"")
        }

        
        switch payTransaction.payEntity {
            case "VisaCard":
                cell.cellImage.image =  UIImage(named: "icon-card-visa")
            case "MasterCard":
                cell.cellImage.image = UIImage(named: "icon-card-master")
            case "DiscoverCard":
                cell.cellImage.image = UIImage(named: "icon-card-discover")
            case "DinersCard":
                cell.cellImage.image = UIImage(named: "icon-card-diners")
            case "AmericanCard":
                cell.cellImage.image = UIImage(named: "icon-card-american")
            case "Aura":
                cell.cellImage.image = UIImage(named: "icon-card-aura")
            case "Elo":
                cell.cellImage.image = UIImage(named: "icon-card-elo")
            case "Hipercard":
                cell.cellImage.image = UIImage(named: "icon-card-hipercard")
            case "TicketVoucher":
                cell.cellImage.image = UIImage(named: "icon-voucher")
            case "TicketPromotion":
                cell.cellImage.image = UIImage(named: "icon-promotion")
            default:
                cell.cellImage.image = UIImage(named: "icon-card-standard")
        }
        return cell
    }
    
   /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45;//Choose your custom row height
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        payTransactionSelect = paymentL[indexPath.section].1[indexPath.row]
        
        if payTransactionSelect.payType == "CARD_PAY"{
            self.performSegue(withIdentifier:"CardPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "VOUCHER_PAY"{
            self.performSegue(withIdentifier:"VoucherPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "PROMOTION_PAY"{
            self.performSegue(withIdentifier:"PromotionPayOperationView", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.groupTableViewBackground
        header.textLabel!.textColor = UIColor.darkGray
        header.textLabel!.font = UIFont(name:"Avenir", size:20)
       // header.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        header.textLabel!.frame = header.frame
    }
 }
