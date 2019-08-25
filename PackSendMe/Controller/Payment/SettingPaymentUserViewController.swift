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
    var paymentL = [(String,Array<PaymentMethodAccountDto>)]()
    let paymentHelper = PaymentHelper()
    var payTransactionSelect = PaymentMethodAccountDto()
    let payOperationTransaction : String = ""

    @IBOutlet weak var paymentTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTitle.text = NSLocalizedString("payment-title-methodopay", comment:"")
        //self.tablePayment.rowHeight = UITableViewAutomaticDimension
        loadPaymentMethodAccount()
    }
    
    func loadPaymentMethodAccount(){
        let url = URLConstants.ACCOUNT.accountpay_http
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone

        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        print("111111 PAYMENTL 5555555555 : ")
                        let jsonAccount = try! (JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any])
                       self.jsonAccountFinal = jsonAccount!["body"] as? [String:Any]
                        self.paymentL = self.paymentHelper.makePaymentAccount(paymentAccountArray: self.jsonAccountFinal!)
                       print("PAYMENTL 10000: \(self.paymentL.count)")
                        self.refreshTable()
                    }
                    else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.NOTFOUND{
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                  }
                }
            }
        }, failure: { (data, response, error) in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: NSLocalizedString(NSLocalizedString("error-title-failconnection", comment:""), comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated:  true)
            }
        })
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
            print (" URL prepare = \(payTransactionSelect.payType)")
            let cardpayVC = segue.destination as? CardPaymentViewController
            cardpayVC?.cardpaySelect = payTransactionSelect
        }
        if segue.identifier == "PromotionPayOperationView"{
        }
    }
   
}

extension SettingPaymentUserViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentL[section].1.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        
        if payTransaction.payType != "OperationMenu"{
            let mySubstring = "•••• "+payTransaction.payCodenum!.suffix(3)
            cell.identificador1Label.text = String(mySubstring) as String
            
            if payTransaction.payStatus == "Inactive" {
                cell.identificador1Label.textColor = UIColor.red
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
                    cell.cellImage.image = UIImage(named: "icon-card-standar")
            }
        }
        else if payTransaction.payType == "OperationMenu"{
            cell.identificador1Label.text = payTransaction.payName
            cell.identificador1Label.textColor = UIColor.blue
                //cell.backgroundColor = UIColor.groupTableViewBackground
            cell.identificador1Label.frame.origin = CGPoint(x: 10, y: 20)
            cell.accessoryType = .none
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
        
        if payTransactionSelect.payType == "OperationMenuVoucher"{
            self.performSegue(withIdentifier:"VoucherPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "OperationMenuCard"{
            self.performSegue(withIdentifier:"CardPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "OperationMenuPromotion"{
            self.performSegue(withIdentifier:"PromotionPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "CARD_PAY"{
            self.performSegue(withIdentifier:"CardPayOperationView", sender: nil)
            print (" URL didSelectRowAt = \(payTransactionSelect.payType)")
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
