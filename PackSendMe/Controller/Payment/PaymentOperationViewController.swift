//
//  PaymentCrudViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 21/06/2019.
//  Copyright © 2019 Ricardo Marzochi. All rights reserved.
//

import Foundation
import UIKit

class PaymentOperationViewController: UIViewController {

    //Screen Operation Payment : EDIT or DELETE
    @IBOutlet weak var titleOpLabel: UILabel!
    @IBOutlet weak var numcardOpLabel: UILabel!
    @IBOutlet weak var numcardOpInpLabel: UILabel!
    @IBOutlet weak var expdateOpLabel: UILabel!
    @IBOutlet weak var expdateOpInpLabel: UILabel!
    @IBOutlet weak var editOpBtn: UIButton!
    @IBOutlet weak var deleteOpBtn: UIButton!
    
    //Screen Type Payment : Card / Paypoul / XXXX
    @IBOutlet weak var titleTypePayLabel: UILabel!
    @IBOutlet weak var typepayTable: UITableView!
    
    var operationPay : String? = nil
    
    var cardObj : CardPaymentModel? = (nil)
    var paymentMethodObj = PaymentMethodAccountDto()
    var paymentMethodL = [PaymentMethodAccountDto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if operationPay == "OperationEditDeletePayment"{
            setupOperationEditDeletePayment()
        }
        else if operationPay == "OperationAddTypePayment"{
            setupOperationPaymentAddType()
        }
    }
    
    func setupOperationEditDeletePayment(){
        titleOpLabel.text = cardObj?.cardType
        numcardOpLabel.text = NSLocalizedString("paymentadd-field-cardnumber", comment:"")
        numcardOpInpLabel.text = cardObj?.cardNumber
        expdateOpLabel.text = NSLocalizedString("paymentadd-field-cardexpdate", comment:"")
        expdateOpInpLabel.text = cardObj?.cardExpiry
        editOpBtn.titleLabel?.text = NSLocalizedString("paymentadd-btn-editpayment", comment:"")
        deleteOpBtn.titleLabel?.text = NSLocalizedString("paymentadd-btn-deletepayment", comment:"")
    }
    
    func setupOperationPaymentAddType(){
        titleTypePayLabel.text = NSLocalizedString("payment-title-addpayment", comment:"")
        loadPaymentMethod()
    }
    
    
    func loadPaymentMethod(){
        let url = URLConstants.PAYMENT.payment_method
        
        HttpClientApi.instance().makeAPICall(url: url, params:nil, method: .GET, success: { (data, response, error) in
            if data != nil {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        let jsonPayment = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String:  Any]
                        var bodyMethodL = jsonPayment!["body"] as! [String:Any]
                        let payMethodL = bodyMethodL["payment"] as! [[String: Any]]

                        for methodPay in payMethodL {
                            if let namePayMethod = methodPay["namePayMethod"] as? String {
                       //         self.paymentMethodObj.namePayMethod = namePayMethod
                            }
                            if let typePayMethod = methodPay["typePayMethod"] as? String {
                       //         self.paymentMethodObj.typePayMethod = typePayMethod
                            }
                       //     print(" pament \(self.paymentMethodObj.namePayMethod)")
                            self.paymentMethodL.append(self.paymentMethodObj)
                      //      self.paymentMethodObj = PaymentMethodModel()
                        }
                        self.refreshTable()
                    }
                    else{
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated:  true)
                        }
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

    
    
    @IBAction func editPayment(_ sender: Any) {
    }
    
    @IBAction func deletePayment(_ sender: Any) {
        
        let deleteConfirmBtn = NSLocalizedString("payment-titlebtnscreen-paymentdelete", comment:"")
        let deleteCancelBtn = NSLocalizedString("payment-titlebtnscreen-paymentcancel", comment:"")

        let titleDeleteMsg = NSLocalizedString("payment-titlescreen-paymentdelete", comment:"")
        let bodyDeleteMsg = NSLocalizedString("payment-msgscreen-paymentdelete", comment:"")
        
        // Declare Alert
        let dialogMessage = UIAlertController(title: titleDeleteMsg, message: bodyDeleteMsg, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: deleteConfirmBtn, style: .default, handler: { (action) -> Void in
            print("Ok button click...")
            self.deletePaymentSelect()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: deleteCancelBtn, style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deletePaymentSelect() {
        let url = URLConstants.PAYMENT.payment_http
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+"/"+(cardObj!.cardNumber)!
        
        print(" deletePaymentSelect paramsDictionary : \(paramsDictionary)")
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier:"PaymentSettingOperationDelete", sender: nil)
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-body-failconnection", comment:""), preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated:  true)
                        }
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
                self.typepayTable.reloadData()
            }
        }
    }
    
}

extension PaymentOperationViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  paymentMethodL.count >= 1 {
            return paymentMethodL.count
        }
        else{
            return 1;
        }
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 20;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentCell") as? SettingViewCell
            else{
                return UITableViewCell()
        }
        //let cellSpacingHeight: CGFloat = 5
        cell.identificador1Label.font = UIFont(name:"Avenir", size:18)
        cell.identificador1Label.textColor = UIColor.darkGray
        //cell.layer.borderWidth = 1
        //cell.layer.cornerRadius = 8
 
        if paymentMethodL.count >= 1 {
         /*   switch paymentMethodL[indexPath.row].typePayMethod {
                case "Card":
                    cell.creditcardImage.image =  UIImage(named: "icon-card-visa")
                case "Paypal":
                    cell.creditcardImage.image = UIImage(named: "icon-card-master")
                default:
                    cell.creditcardImage.image = UIImage(named: "icon-card-standar")
                }
                print("LINE pament \(indexPath)")
                print("LINE pament \(paymentMethodL[indexPath.row].namePayMethod!)")
                cell.identificador1Label.text = paymentMethodL[indexPath.row].namePayMethod!
 */
            }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      /*  if(indexPath.row == 0){
            self.performSegue(withIdentifier:"SettingDataAccountViewToSettingProfileUserView", sender: nil)
        }*/
    }
}
