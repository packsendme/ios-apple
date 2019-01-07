//
//  SettingDataViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SettingDataViewController: UIViewController {
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    let loadingView = UIView()
    var accountHelper = AccountHelper()
    var accountModel = AccountModel()
    var itens : [[String]] = []
    var jsonAccountFinal : [String: Any]? = nil
    var boxActivityView = UIView()
    
    /// Spinner shown during load the TableView
    let activityIndicator = UIActivityIndicatorView()
     let loadingLabel = UILabel()
    
    override func viewDidLoad() {
       //self.activityIndicator.startAnimating()
        //activityActionStart()
     //   loadingScreen()
        //activityActionStart()
        settingTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        loadAccount()
        
        settingTable.rowHeight = UITableViewAutomaticDimension
        settingTable.isScrollEnabled = true
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        
        settingTable.delegate = self
        settingTable.dataSource = self
         super.viewDidLoad()
     }

    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.loadingView.removeFromSuperview()
       // self.activityView.stopAnimating()
    }
    
   
    // Set the activity indicator into the main view
    private func loadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
       
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (settingTable.frame.width / 2) - (width / 2)
        let y = (settingTable.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        settingTable.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
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
                        if(jsonAccount != nil){
                            self.jsonAccountFinal = jsonAccount!["body"] as! [String:Any]
                            
                            //jsonAccountFinal = parseHTTPDataToAccountModel(json:jsonResponse!)
                            
                            //self.activityActionStart()
                            //self.startAnimating(title:NSLocalizedString("photoprofile-activity-load", comment:""))
                            self.refreshTable()
                        //    self.removeLoadingScreen()
                            
                            self.activityActionStop()
                            //self.activityIndicator.stopAnimating()
                            self.accountModel = self.accountHelper.transformArrayToAccountModel(account: jsonAccount!)
                            
                            
                        }
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
    
    @IBAction func homeToolBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier:URLConstants.ACCOUNT.allViewToAccountHomeView, sender: nil)
    }
    
    @IBAction func menuToolBtnAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
    self.performSegue(withIdentifier:URLConstants.ACCOUNT.allViewToAccountHomeView, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SettingProfileUserViewController
        {
            let setupAccessUser = segue.destination as? SettingProfileUserViewController
            setupAccessUser?.accountModel = accountModel
        }
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

                if UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as? NSData != nil{
                    let data = UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as! NSData
                    imagePersonalView.image = UIImage(data: data as Data)
                    cell.cellImage?.image = imagePersonalView.image
                    let radius = cell.cellImage.frame.width / 2
                    cell.cellImage.layer.cornerRadius = radius
                    cell.cellImage.layer.masksToBounds = true
                }
                else{
                    imagePersonalView.image = UIImage(named: GlobalVariables.sharedManager.profileImageDefault)
                    cell.cellImage?.image = imagePersonalView.image
                    let radius = cell.cellImage.frame.width / 2
                    cell.cellImage.layer.cornerRadius = radius
                    cell.cellImage.layer.masksToBounds = true
                }
                
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
                imageAddressView.image = UIImage(named: "icon-user-house.png")
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
                imageAddressView.image = UIImage(named: "icon-user-work.png")
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
            
            // PAYMENT ACCOUNT MASTER
            if(indexPath.row == 3){
                cell.titleCellLabel.text = NSLocalizedString("setting-title-paymentmaster", comment:"")
                cell.cellImage.image = UIImage(named: "icon-user-card.png")
                let paymentArray = jsonAccountFinal!["payment"] as? [[String:Any]]
                cell.creditcardImage.isHidden = false

                if paymentArray != nil {
                    for payment in paymentArray! {
                        if payment["cardOrder"] as? Int == 1  {
                            cell.identificador1Label.text = ""
                            let cardType = payment["cardType"] as? String
                            switch cardType {
                                case "Visa":
                                    cell.creditcardImage.image = UIImage(named: "icon-card-visa.png")
                                case "Mastercard":
                                    cell.creditcardImage.image = UIImage(named: "icon-card-master.png")
                                case "Discovercard":
                                    cell.creditcardImage.image = UIImage(named: "icon-card-discover.png")
                                case "Dinerscard":
                                    cell.creditcardImage.image = UIImage(named: "icon-card-diners.png")
                                case "Americancard":
                                    cell.creditcardImage.image = UIImage(named: "icon-card-american.png")
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
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:17)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addcard", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:17)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addcard", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                }
            }
            // PAYMENT ACCOUNT OPTIONAL
            if(indexPath.row == 4){
                cell.titleCellLabel.text = NSLocalizedString("setting-title-paymentoptional", comment:"")
                cell.cellImage.image = UIImage(named: "icon-user-card.png")
                let paymentArray = jsonAccountFinal!["payment"] as? [[String:Any]]
                cell.creditcardImage.isHidden = false
                
                if paymentArray != nil {
                    for payment in paymentArray! {
                        cell.identificador1Label.text = ""
                        if payment["cardOrder"] as? Int == 2  {
                            
                            let cardType = payment["cardType"] as? String
                            switch cardType {
                            case "Visa":
                                cell.creditcardImage.image = UIImage(named: "icon-card-visa.png")
                            case "Mastercard":
                                cell.creditcardImage.image = UIImage(named: "icon-card-master.png")
                            case "Discovercard":
                                cell.creditcardImage.image = UIImage(named: "icon-card-discover.png")
                            case "Dinerscard":
                                cell.creditcardImage.image = UIImage(named: "icon-card-diners.png")
                            case "Americancard":
                                cell.creditcardImage.image = UIImage(named: "icon-card-american.png")
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
                            cell.identificador2Label.font = UIFont(name:"Avenir", size:17)
                            cell.identificador2Label.textColor = UIColor.blue
                            cell.identificador2Label.text = NSLocalizedString("setting-title-addcard", comment:"")
                            cell.identificador3Label.text = ""
                            cell.identificador1Label.text = ""
                        }
                    }
                }
                else{
                    cell.identificador2Label.font = UIFont(name:"Avenir", size:17)
                    cell.identificador2Label.textColor = UIColor.blue
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addcard", comment:"")
                    cell.identificador3Label.text = ""
                    cell.identificador1Label.text = ""
                    //0F49B3
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingDataAccountViewToSettingProfileUserView, sender: nil)
        }
        else if(indexPath.row == 1){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerAddressView, sender: nil)
        }
        else if(indexPath.row == 2){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerAddressView, sender: nil)
        }
        else if(indexPath.row == 3){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerPaymentView, sender: nil)
        }
        else if(indexPath.row == 4){
            self.performSegue(withIdentifier:URLConstants.ACCOUNT.settingViewToManagerPaymentView, sender: nil)
        }
    }
 

}

    
    



