//
//  EditPaymentUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class APPaySearchViewController: UIViewController {
    
    @IBOutlet weak var labelTitleScreenPay: UILabel!
    @IBOutlet weak var tablePayment: UITableView!
    var jsonAccountFinal : [String: Any]? = nil
    var paymentL = [(String,Array<PaymentAccountBO>)]()
    let paymentBO = PaymentAccountBO()
    var payTransactionSelect = PaymentAccountBO()
    var paymentService = PaymentService()
    @IBOutlet weak var paymentTitle: UILabel!

    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTitle.text = NSLocalizedString("payment-title-methodopay", comment:"")
        //self.tablePayment.rowHeight = UITableViewAutomaticDimension
        self.activityActionStart(title : NSLocalizedString("a-action-lbl-loading", comment:""))
        loadPaymentMethodAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPaymentMethodAccount(){
        paymentService.getPaymentsByUsername(){(success, response, error) in
            
            if success == true{
                self.paymentL = response as! [(String,Array<PaymentAccountBO>)]
                DispatchQueue.main.async {
                    self.tablePayment.reloadData()
                    self.activityActionStop()
                    
                    UIView.transition(with: self.view,
                                    duration:0.5,
                                    options: .transitionCrossDissolve,
                                    animations: {
                                    self.tablePayment.reloadData()},
                                    completion: nil)
                }
                self.activityActionStop()
            }
            else if success == false{
                if error != nil{
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated:  true)
                    }
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "VoucherPayOperationView"{

        }
        if segue.identifier == "APPayCardViewController"{
            let cardpayVC = segue.destination as? APPayCardViewController
            cardpayVC?.cardpaySelect = payTransactionSelect
        }
        if segue.identifier == "PromotionPayOperationView"{
        
        }
    }
    
    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 35, y: view.frame.midY - 40, width:50, height: 50))
        boxActivityView.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        //UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        //Here the spinnier is initialized
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.black
        activityView.startAnimating()
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.black
        textLabel.text = ""
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
}

extension APPaySearchViewController : UITableViewDataSource, UITableViewDelegate{
    
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
       guard let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentCell", for: indexPath) as? SettingViewCell
        else{
          return UITableViewCell()
        }

        cell.identificador1Label.font = UIFont(name:"Avenir", size:18)
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
        else{
            cell.identificador1Label.frame.origin = CGPoint(x: 20, y: 16)

        }
        
        if payTransaction.payStatus == GPConstants.validateCard.rawValue {
            cell.identificador3Label.textColor = UIColor.blue
            cell.identificador3Label.font = UIFont(name:"Avenir", size:16)
            cell.identificador3Label.text = NSLocalizedString("payment-title-statusvalidated", comment:"")
        }
        else if payTransaction.payStatus == GPConstants.invalidCard.rawValue {
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
                cell.cellImage.image = UIImage(named: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        payTransactionSelect = paymentL[indexPath.section].1[indexPath.row]
        
        if payTransactionSelect.payType == "CARD_PAY"{
            self.performSegue(withIdentifier:"APPayCardViewController", sender: nil)
        }
        else if payTransactionSelect.payType == "VOUCHER_PAY"{
            self.performSegue(withIdentifier:"VoucherPayOperationView", sender: nil)
        }
        else if payTransactionSelect.payType == "PROMOTION_PAY"{
            self.performSegue(withIdentifier:"PromotionPayOperationView", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.groupTableViewBackground
        header.textLabel!.textColor = UIColor.black
        header.textLabel!.font = UIFont(name:"Avenir", size:20)
       // header.textLabel!.font = UIFont.boldSystemFont(ofSize: 17)
        header.textLabel!.frame = header.frame
    }
 }
