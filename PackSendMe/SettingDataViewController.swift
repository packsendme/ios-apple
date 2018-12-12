//
//  SettingDataViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SettingDataViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var settingTable: UITableView!
    
    var accountHelper = AccountHelper()
    var accountObj = AccountModel()
    var itens : [[String]] = []
    var jsonAccountFinal : [String: Any]? = nil
    
    override func viewDidLoad() {
       
        //startLoading()
        
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        activityIndicator.startAnimating();
        
        loadAccount()
        settingTable.rowHeight = UITableViewAutomaticDimension
        settingTable.isScrollEnabled = true
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        
        settingTable.delegate = self
        settingTable.dataSource = self
         super.viewDidLoad()
     }

    
    
    func loadAccount(){
        GlobalVariables.sharedManager.username = "+5596064241"
        let paramsDictionary : String = GlobalVariables.sharedManager.username+URLConstants.ACCOUNT.account_load
        let url = URLConstants.ACCOUNT.account_http
        
        print (" URL NOW = \(url)")
        
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        let jsonAccount = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                        self.jsonAccountFinal = jsonAccount!["body"] as! [String:Any]
                        //jsonAccountFinal = parseHTTPDataToAccountModel(json:jsonResponse!)
                        self.refreshTable()
                                                }
                    else if response?.statusCode == URLConstants.HTTP_STATUS_CODE.FOUND{
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
                self.settingTable.reloadData()
            }
        }
    }
    
    func parseHTTPDataToAccountModel(json : [String: Any]) -> [[Any]]{
        let accountArray = json["body"] as! [String:Any]
        let paymentArray = accountArray["payment"] as! [[String:Any]]
        let addressArray = accountArray["address"] as! [[String:Any]]
        let jsonAccountFinal = [[accountArray],[addressArray],[paymentArray]]
        return jsonAccountFinal
    }
    
    
}

extension SettingDataViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"SettingCell") as? SettingViewCell
            else{
                return UITableViewCell()
        }
  
        if(jsonAccountFinal != nil){
            
            // USER ACCOUNT
            if(indexPath.row == 0){
                cell.titleCellLabel.text = NSLocalizedString("setting-title-personalinf", comment:"")
                cell.creditcardImage.isHidden = true
                var imagePersonalView : UIImageView
                imagePersonalView  = UIImageView(frame:CGRect(x: 0, y: 0,width:1, height:1));
                imagePersonalView.image = UIImage(named:"icon-user.png")
                imagePersonalView.contentMode = .scaleToFill
                
                cell.cellImage?.image = imagePersonalView.image
                //imageWithImage(image: UIImage(named:"icon-user")!, scaledToSize: CGSize(width: 30, height: 30))

                
                if let name = jsonAccountFinal!["name"] as? String {
                    cell.identificador1Label.text = name
                }
                if let username = jsonAccountFinal!["username"] as? String {
                    print(" username =\(username)")
                   cell.identificador2Label.text = username
                }
                if let email = jsonAccountFinal!["email"] as? String {
                    print(" email =\(email)")
                    cell.identificador3Label.text = email
                }
            }
            // ADDRESS-HOME ACCOUNT
            if(indexPath.row == 1){
                var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-house.png")
                cell.titleCellLabel.text = NSLocalizedString("setting-title-addresshome", comment:"")
                cell.creditcardImage.isHidden = true
                cell.cellImage.image = imageAddressView.image
                
                let addressArray = jsonAccountFinal!["address"] as? [[String:Any]]
                
                if addressArray != nil {
                    for address in addressArray! {

                        if address["type"] as! String == "home" {
                            
                            if let address = address["address"] as? String {
                                print(" address =\(address)")
                                cell.identificador1Label.text = address
                                cell.identificador1Label.textColor = UIColor.black
                            }
                            if let city = address["city"] as? String {
                                print(" city =\(city)")
                                cell.identificador2Label.text = city
                                cell.identificador2Label.textColor = UIColor.black

                            }
                            if let country = address["country"] as? String {
                                print(" country =\(country)")
                                cell.identificador3Label.text = country
                            }
                            break
                        }
                        else{
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addhome", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                }
            }
            // ADDRESS-WORK ACCOUNT
            if(indexPath.row == 2){
                var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-work.png")
                cell.titleCellLabel.text = NSLocalizedString("setting-title-addresswork", comment:"")
                cell.creditcardImage.isHidden = true
                cell.cellImage.image = imageAddressView.image
                
                let addressArray = jsonAccountFinal!["address"] as? [[String:Any]]
                
                if addressArray != nil {
                    for address in addressArray! {
                        
                        if address["type"] as! String == "work" {
                            
                            if let address = address["address"] as? String {
                                print(" address =\(address)")
                                cell.identificador1Label.text = address
                                cell.identificador1Label.textColor = UIColor.black
                            }
                            if let city = address["city"] as? String {
                                print(" city =\(city)")
                                cell.identificador2Label.text = city
                                cell.identificador2Label.textColor = UIColor.black
                            }
                            if let country = address["country"] as? String {
                                print(" country =\(country)")
                                cell.identificador3Label.text = country
                            }
                            break
                        }
                        else{
                            print(" ADDRESS TYPE =\(address["type"] as! String) ")
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                }
            }
            // PAYMENT ACCOUNT
            if(indexPath.row == 3){
                cell.titleCellLabel.text = NSLocalizedString("setting-title-paymentinf", comment:"")
                cell.cellImage.image = UIImage(named: "icon-card.png")
                let paymentArray = jsonAccountFinal!["payment"] as? [[String:Any]]
                cell.creditcardImage.isHidden = false

                if paymentArray != nil {
                    for payment in paymentArray! {
                        if payment["cardOrder"] as? Int == 1  {
                            cell.identificador1Label.text = ""
                            let cardType = payment["cardType"] as? String
                            switch cardType {
                                case "Visa":
                                    cell.creditcardImage.image = UIImage(named: "icon-visa.png")
                                case "Mastercard":
                                    cell.creditcardImage.image = UIImage(named: "icon-mastercard.png")
                                case "Discovercard":
                                    cell.creditcardImage.image = UIImage(named: "icon-discovercard.png")
                                case "Dinerscard":
                                    cell.creditcardImage.image = UIImage(named: "icon-dinerscard.png")
                                case "Americancard":
                                    cell.creditcardImage.image = UIImage(named: "icon-americancard.png")
                                default:
                                    print("F. You failed")//Any number less than 0 or greater than 99
                            }

                            if let cardName = payment["cardName"] as? String {
                                print(" country =\(cardName)")
                                cell.identificador3Label.text = cardName
                            }
                            
                            if let cardNumber = payment["cardNumber"] as? String {
                                print(" city =\(cardNumber)")
                                cell.identificador2Label.text = cardNumber
                            }
                            break
                        }
                        else{
                            cell.creditcardImage.image = UIImage(named: "icon-cards.png")
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.creditcardImage.image = UIImage(named: "icon-cards.png")
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                }
            }
            // PAYMENT ACCOUNT
            if(indexPath.row == 4){
                cell.titleCellLabel.text = NSLocalizedString("setting-title-paymentinf", comment:"")
                cell.cellImage.image = UIImage(named: "icon-card.png")
                let paymentArray = jsonAccountFinal!["payment"] as? [[String:Any]]
                cell.creditcardImage.isHidden = false
                
                if paymentArray != nil {
                    for payment in paymentArray! {
                        cell.identificador1Label.text = ""
                        if payment["cardOrder"] as? Int == 2  {
                            
                            let cardType = payment["cardType"] as? String
                            switch cardType {
                            case "Visa":
                                cell.creditcardImage.image = UIImage(named: "icon-visa.png")
                            case "Mastercard":
                                cell.creditcardImage.image = UIImage(named: "icon-mastercard.png")
                            case "Discovercard":
                                cell.creditcardImage.image = UIImage(named: "icon-discovercard.png")
                            case "Dinerscard":
                                cell.creditcardImage.image = UIImage(named: "icon-dinerscard.png")
                            case "Americancard":
                                cell.creditcardImage.image = UIImage(named: "icon-americancard.png")
                            default:
                                print("F. You failed")//Any number less than 0 or greater than 99
                            }
                            
                            if let cardName = payment["cardName"] as? String {
                                print(" country =\(cardName)")
                                cell.identificador3Label.text = cardName
                            }
                            
                            if let cardNumber = payment["cardNumber"] as? String {
                                print(" city =\(cardNumber)")
                                cell.identificador2Label.text = cardNumber
                            }
                            break
                        }
                        else{
                            cell.creditcardImage.image = UIImage(named: "icon-cards.png")
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.creditcardImage.image = UIImage(named: "icon-cards.png")
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:18)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    
 

}
    
    
    



