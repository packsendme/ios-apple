//
//  SettingDataViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//
import UIKit
import GooglePlaces


class APSearchViewController: UIViewController {
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    
    var headerHeightConstraint:NSLayoutConstraint!
    
    let loadingView = UIView()
    var itens : [[String]] = []
    var jsonAccountFinal : [String: Any]? = nil
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var typeAddress : String? = nil
    var addressUserArray : [String:Any]? = nil
    var lastContentOffset: CGFloat = 0

    var profileObj : ProfileBO?
    var amService = AccountService()
    var addressObj = AddressBO()

    var oldContentOffset = CGPoint()
    let topConstraintRange = (CGFloat(120)..<CGFloat(300))
    var tableRowNumber : Int = 10
    var profileImageDefault: String = "icon-user-photo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        self.activityActionStart(title : NSLocalizedString("a-action-lbl-loading", comment:""))
        loadAccount()
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.decelerationRate = UIScrollViewDecelerationRateFast
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

    override func didReceiveMemoryWarning() {
           print(" DEALOCK MEMORY")
        super.didReceiveMemoryWarning()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is APPSearchViewController
        {
            let aupsetting = segue.destination as? APPSearchViewController
            aupsetting!.profileObj = self.profileObj!
        }
        else if segue.destination is APAManagerViewController
        {
            let setupAddress = segue.destination as? APAManagerViewController
            setupAddress?.typeAddress = typeAddress
        }
    }
    
    func refreshTable() {
        DispatchQueue.main.async(execute: { () -> Void in
             self.settingTable.reloadData()
            self.activityActionStop()
        })
    }
    
    // -------------------------------------------------------------------------------------
    // FUNCTION : loadAccount()
    // TYPE : HTTP
    // ACTION :  GET
    // -------------------------------------------------------------------------------------
    func loadAccount(){
        amService.getLoadAccountUser(){(success, response, error) in
            if success == true{
                self.profileObj = response as? ProfileBO
                DispatchQueue.main.async {
                    self.settingTable.reloadData()
                    self.activityActionStop()
                
                    UIView.transition(with: self.view,
                                  duration:0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.settingTable.reloadData()},
                                  completion: nil)
                
                }
            self.activityActionStop()
            }
            else if success == false{
                DispatchQueue.main.async() {
                    let ac = UIAlertController(title: NSLocalizedString("error-title-failconnection", comment:""), message: NSLocalizedString("error-msg-failconnection", comment:""), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
        }
    }
    
}


extension APSearchViewController : UITableViewDataSource, UITableViewDelegate{
    
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
        let addressObj = AddressBO()
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"SettingInformationCell") as? SettingViewCell
            else{
                return UITableViewCell()
        }
        if(profileObj != nil){
            // ADDRESS-HOME ACCOUNT
            if(indexPath.row == 0){
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.groupTableViewBackground
                cell.accessoryType = .none
            }
            
            // USER ACCOUNT
            if(indexPath.row == 1){
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
                    imagePersonalView.image = UIImage(named: profileImageDefault)
                    cell.cellImage?.image = imagePersonalView.image
                    let radius = cell.cellImage.frame.width / 2
                    cell.cellImage.layer.cornerRadius = radius
                    cell.cellImage.layer.masksToBounds = true
                }
                
                cell.identificador1Label.text = profileObj!.name
                cell.identificador2Label.text = profileObj!.username
                cell.identificador3Label.text = profileObj!.email
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
                cell.identificador2Label.text = NSLocalizedString("setting-title-addhome", comment:"")

                if profileObj!.address != nil {
                    for address in profileObj!.address! {
                        if (address.type == addressObj.addressTypeHome) {
                            cell.identificador1Label.text = address.address
                            cell.identificador2Label.text = address.city
                            cell.identificador3Label.text = address.country
                            cell.identificador1Label.textColor = UIColor.black
                        }
                    }
                }
            }
            // ADDRESS-JOB ACCOUNT
            if(indexPath.row == 4){
               var imageAddressView : UIImageView
                imageAddressView  = UIImageView(frame:CGRect(x: 0, y: 0,width:10, height:10));
                imageAddressView.image = UIImage(named: "icon-user-work.png")
                cell.cellImage.image = imageAddressView.image
                cell.identificador2Label.text = NSLocalizedString("setting-title-addwork", comment:"")

                if profileObj!.address != nil {
                    for address in profileObj!.address! {
                        if (address.type == addressObj.addressTypeJob) {
                            cell.identificador1Label.text = address.address
                            cell.identificador2Label.text = address.city
                            cell.identificador3Label.text = address.country
                            cell.identificador1Label.textColor = UIColor.black
                        }
                    }
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
            self.performSegue(withIdentifier:"APPSearchViewController", sender: nil)
        }
            // AddressHome
        else if(indexPath.row == 3){
            typeAddress = addressObj.addressTypeHome
            self.performSegue(withIdentifier:"APAManagerViewController", sender: nil)
        }
            // AddressJob
        else if(indexPath.row == 4){
            typeAddress = addressObj.addressTypeJob
            self.performSegue(withIdentifier:"APAManagerViewController", sender: nil)
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
