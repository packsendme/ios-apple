//
//  SettingDataViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//
import UIKit
import GooglePlaces


class SettingDataViewController: UIViewController {
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    
    var headerHeightConstraint:NSLayoutConstraint!
    
    let loadingView = UIView()
    var accountHelper = AccountHelper()
    var addressParser = ParserHelper()
    var itens : [[String]] = []
    var jsonAccountFinal : [String: Any]? = nil
    var boxActivityView = UIView()
    var typeAddressChange : String? = nil
    var addressUserArray : [String:Any]? = nil
    
    var menuconfigAccount = AccountDto()

    var lastContentOffset: CGFloat = 0

    var oldContentOffset = CGPoint()
    let topConstraintRange = (CGFloat(120)..<CGFloat(300))
    var tableRowNumber : Int = 10
    
    override func viewDidLoad() {
        //self.activityIndicator.startAnimating()
        //activityActionStart()
        //   loadingScreen()
        //activityActionStart()
        settingTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        loadAccount()
        
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.decelerationRate = UIScrollViewDecelerationRateFast
        super.viewDidLoad()
    }
    
    func loadAccount(){
        //GlobalVariables.sharedManager.username = "+5596064241"
        let paramsDictionary : String = GlobalVariables.sharedManager.usernameNumberphone+URLConstants.ACCOUNT.account_load
        let url = URLConstants.ACCOUNT.account_http
        HttpClientApi.instance().makeAPICall(url: url, params:paramsDictionary, method: .GET, success: { (data, response, error) in
            //print (" URL statusCode = \(response?.statusCode)")
            if let data = data {
                do{
                    if response?.statusCode == URLConstants.HTTP_STATUS_CODE.OK{
                        
                        let jsonAccount = try! JSONSerialization.jsonObject(with: data, options: []) as? [String:  Any]
                        if(jsonAccount != nil){
                            self.jsonAccountFinal = jsonAccount!["body"] as? [String:Any]
                            self.menuconfigAccount = AccountHelper().getMenuConfiguration(jsonAccount: self.jsonAccountFinal!)
                            self.refreshTable()
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
            setupAccessUser?.accountModel = menuconfigAccount
        }
        else if segue.destination is SettingAddressUserViewController
        {
            let setupAccessUser = segue.destination as? SettingAddressUserViewController
            setupAccessUser?.typeAddressChange = typeAddressChange
            //addressUserArray = jsonAccountFinal!["address"] as? [String:Any]
            //setupAccessUser?.addressUserArray = addressUserArray
        }
        
    }
}


extension SettingDataViewController : UITableViewDataSource, UITableViewDelegate{
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        guard var cell = tableView.dequeueReusableCell(withIdentifier:"SettingInformationCell") as? SettingViewCell
            else{
                return UITableViewCell()
        }
 
        if(menuconfigAccount != nil){
            
            // ADDRESS-HOME ACCOUNT
            if(indexPath.row == 0){
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .none
            }
            
            // USER ACCOUNT
            if(indexPath.row == 1){
                //cell.titleCellLabel.text = NSLocalizedString("setting-title-personalinf", comment:"")
                //cell.creditcardImage.isHidden = true
                
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
                
                cell.identificador1Label.text = menuconfigAccount.name
                cell.identificador2Label.text = menuconfigAccount.username
                cell.identificador3Label.text = menuconfigAccount.email
            }
            // NULL BLANCK CELL
            if(indexPath.row == 2){
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .none
            }
            // ADDRESS-HOME ACCOUNT
            if(indexPath.row == 3){
                cell.selectionStyle = .none
                var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-user-house.png")
                cell.cellImage.image = imageAddressView.image
                
                if menuconfigAccount.address != nil {
                    for address in menuconfigAccount.address! {
                        if (address.type as! String == GlobalVariables.sharedManager.addressTypeHome) {
                            cell.identificador1Label.text = address.address
                            cell.identificador2Label.text = address.city
                            cell.identificador3Label.text = address.country
                            cell.identificador1Label.textColor = UIColor.black
                        }
                    }
                }
                else{
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addhome", comment:"")
                }
            }
            // ADDRESS-JOB ACCOUNT
            if(indexPath.row == 4){
                var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-user-work.png")
                cell.cellImage.image = imageAddressView.image
                
                if menuconfigAccount.address != nil {
                    for address in menuconfigAccount.address! {
                        if (address.type == GlobalVariables.sharedManager.addressTypeJob) {
                            cell.identificador1Label.text = address.address
                            cell.identificador2Label.text = address.city
                            cell.identificador3Label.text = address.country
                            cell.identificador1Label.textColor = UIColor.black
                        }
                    }
                }
                else{
                    cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")
                }
            }
            
            if(indexPath.row == 5){
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .none
            }
            // SECURITY
            if(indexPath.row == 6){
                var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-user-security.png")
                cell.cellImage.image = imageAddressView.image
                cell.identificador2Label.text = NSLocalizedString("setting-title-security", comment:"")
            }
            
            // EXIT
            if(indexPath.row == 7){
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .none
            }
            // EXIT
            if(indexPath.row == 8){
                cell.identificador2Label.text = NSLocalizedString("setting-title-exit", comment:"")
                cell.identificador2Label.textColor = UIColor.red
                cell.backgroundColor = UIColor.white
            }
        }
         return cell;
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 30.0
        }
        if indexPath.row == 1 {
            return 85.0
            
        }
        if indexPath.row == 2 {
            return 50.0
            
        }
        if indexPath.row == 3 || indexPath.row == 4 {
            return 90.0
            
        }
        if indexPath.row == 5 {
            return 70.0
            
        }
        if indexPath.row == 6 {
            return 90.0
        }
        if indexPath.row == 7 {
            return 70.0
        }
        if indexPath.row == 8 {
            return 90.0
        }
        else{
            return 90.0;
        }
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1){
            self.performSegue(withIdentifier:"SettingProfileUserViewControllerGo", sender: nil)
        }
            // AddressHome
        else if(indexPath.row == 3){
            typeAddressChange = GlobalVariables.sharedManager.addressTypeHome
            self.performSegue(withIdentifier:"SettingViewToManagerAddressView", sender: nil)
        }
            // AddressJob
        else if(indexPath.row == 4){
            typeAddressChange = GlobalVariables.sharedManager.addressTypeJob
            self.performSegue(withIdentifier:"SettingViewToManagerAddressView", sender: nil)
        }
            // Payment Main
        else if(indexPath.row == 6){
            //self.performSegue(withIdentifier:"SettingViewToManagerPaymentView", sender: nil)
        }
            // Payment Second
        else if(indexPath.row == 8){
            //self.performSegue(withIdentifier:"SettingViewToManagerPaymentView", sender: nil)
        }
    }
    

}
