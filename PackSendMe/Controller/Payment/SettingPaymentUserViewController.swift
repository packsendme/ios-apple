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
    @IBOutlet weak var labelTitleMethodPay: UILabel!
    @IBOutlet weak var tablePayment: UITableView!
    var paymentObj : PaymentAccountDto? = nil
    var totNum : Int = 0
    var typeOperation : String = ""
    
    let sectioHeader: [String] = [NSLocalizedString("payment-title-sectionpayment", comment:""),NSLocalizedString("payment-title-sectionvouchers", comment:""),NSLocalizedString("payment-title-addpaymentpromotions", comment:"")]
    
    var cardL: [PaymentAllDto]? = nil
    var voucherL: [PaymentAllDto]? = nil
    var promotionL: [PaymentAllDto]? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        labelTitleScreenPay.text = NSLocalizedString("setting-title-payment", comment:"")
        labelTitleMethodPay.text = NSLocalizedString("setting-title-paymentmethods", comment:"")
    
        self.tablePayment.rowHeight = UITableViewAutomaticDimension
        self.tablePayment.estimatedRowHeight = 60
        
       // self.btnAddPay.setTitle(NSLocalizedString("payment-title-addpayment", comment:"") , for: .normal)
        
        loadPayment()
        
        self.refreshTable()
    }
    
    func loadPayment(){
        let paymentHelper = PaymentHelper()
        let url = URLConstants.ACCOUNT.account_http+"payment/"
        print(" loadPayment url : \(url)")
        let paramsDictionary : String = GlobalVariables.sharedManager.username
        print(" loadPayment paramsDictionary : \(paramsDictionary)")

        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        let jsonAccount = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                        print("jsonAccount : \(jsonAccount)")
                        self.cardL = paymentHelper.parseFromJSONToCardPayment(paymentAccountArray:jsonAccount!)
                        self.voucherL = paymentHelper.parseFromJSONToVoucherPayment(paymentAccountArray:jsonAccount!)
                        self.promotionL = paymentHelper.parseFromJSONToPromotionPayment(paymentAccountArray:jsonAccount!)
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
        if typeOperation == "OperationPaymentAddType"{
            let setupAccessUser = segue.destination as? PaymentOperationViewController
            setupAccessUser?.operationPay = "OperationAddTypePayment"
        }
        else if typeOperation == "OperationEditDeletePayment"{
            let setupAccessUser = segue.destination as? PaymentOperationViewController
            setupAccessUser?.operationPay = "OperationPaymentEditDelete"
        }
    }
    
    @IBAction func addPaymentMethodAction(_ sender: Any) {
        typeOperation = "OperationPaymentAddType"
        self.performSegue(withIdentifier:"OperationPaymentAddType", sender: nil)
    }
    
    
    
}

extension SettingPaymentUserViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionRowTotal : Int = (self.cardL?.count)! + (self.voucherL?.count)! + (self.promotionL?.count)!
        return sectionRowTotal
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectioHeader.count
    }


    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "PaymentHeaderCell") as! SettingViewCell
        headerCell.backgroundColor = UIColor.cyan
        
        switch (section) {
        case 0:
            headerCell.titleHeadLabel.text = sectioHeader[1];
        //return sectionHeaderView
        case 1:
            headerCell.titleHeadLabel.text = sectioHeader[2];
        //return sectionHeaderView
        case 2:
            headerCell.titleHeadLabel.text = sectioHeader[3];
        //return sectionHeaderView
        default:
            headerCell.titleHeadLabel.text = "Other";
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"PaymentCell") as? SettingViewCell
        else{
          return UITableViewCell()
        }
        //let cellSpacingHeight: CGFloat = 5
        cell.identificador1Label.font = UIFont(name:"Avenir", size:18)
        cell.identificador1Label.textColor = UIColor.darkGray

        switch (indexPath.section) {
        case 0:
            switch cardL![indexPath.row].desc5 {
            case "Visa":
                cell.creditcardImage.image =  UIImage(named: "icon-card-visa")
            case "Mastercard":
                cell.creditcardImage.image = UIImage(named: "icon-card-master")
            case "Discovercard":
                cell.creditcardImage.image = UIImage(named: "icon-card-discover")
            case "Dinerscard":
                cell.creditcardImage.image = UIImage(named: "icon-card-diners")
            case "Americancard":
                cell.creditcardImage.image = UIImage(named: "icon-card-american")
            default:
                cell.creditcardImage.image = UIImage(named: "icon-card-standar")
            }
            cell.identificador1Label?.text = self.cardL![indexPath.row].desc2
            
        case 1:
            cell.identificador1Label?.text = self.voucherL![indexPath.row].desc1
        case 2:
            cell.identificador1Label?.text = self.promotionL![indexPath.row].desc1
        //return sectionHeaderView
        default:
            cell.textLabel?.text = "Other"
        }
        
        
        /*
        if paymentObj != nil{
            if paymentObj!.payment != nil{
               var payL = paymentObj!.payment!
               switch payL[indexPath.row].cardType {
                    case "Visa":
                       cell.creditcardImage.image =  UIImage(named: "icon-card-visa")
                    case "Mastercard":
                       cell.creditcardImage.image = UIImage(named: "icon-card-master")
                    case "Discovercard":
                       cell.creditcardImage.image = UIImage(named: "icon-card-discover")
                    case "Dinerscard":
                       cell.creditcardImage.image = UIImage(named: "icon-card-diners")
                    case "Americancard":
                       cell.creditcardImage.image = UIImage(named: "icon-card-american")
                    default:
                       cell.creditcardImage.image = UIImage(named: "icon-card-standar")
                }
                cell.identificador1Label.text = payL[indexPath.row].cardNumber
                
               /* if indexPath.row == totNum {
                    cell.identificador1Label.text = NSLocalizedString("setting-title-addcard", comment:"")
                }*/
            }
        } */
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
           // self.performSegue(withIdentifier:"SettingDataAccountViewToSettingProfileUserView", sender: nil)
        }
    }
 }
