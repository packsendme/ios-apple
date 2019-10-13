//
//  SettingDataViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 10/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//
import UIKit
import GooglePlaces


class AUSettingViewController: UIViewController {
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingTable: UITableView!
    
    var headerHeightConstraint:NSLayoutConstraint!
    
    let loadingView = UIView()
    var accountHelper = AccountHelper()
    var addressParser = ParserHelper()
    var itens : [[String]] = []
    var jsonAccountFinal : [String: Any]? = nil
    var boxActivityView = UIView()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var typeAddressChange : String? = nil
    var addressUserArray : [String:Any]? = nil
    var profileObj : ProfileBO?

    var lastContentOffset: CGFloat = 0

    var oldContentOffset = CGPoint()
    let topConstraintRange = (CGFloat(120)..<CGFloat(300))
    var tableRowNumber : Int = 10
    var amService = AccountService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        self.activityActionStart(title : NSLocalizedString("main-title-loading", comment:""))
        loadAccount()
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.decelerationRate = UIScrollViewDecelerationRateFast
        super.viewDidLoad()
    }
    


    func activityActionStart(title : String) {
        // You only need to adjust this frame to move it anywhere you want
        boxActivityView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 125, width: 180, height: 50))
        boxActivityView.backgroundColor = UIColor.lightGray
        boxActivityView.alpha = 0.9
        boxActivityView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.color = UIColor.blue
        
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.white
        textLabel.text = title
        
        boxActivityView.addSubview(activityView)
        boxActivityView.addSubview(textLabel)
        
        view.addSubview(boxActivityView)
    }
    
    func activityActionStop() {
        //When button is pressed it removes the boxView from screen
        self.boxActivityView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
    @IBAction func homeToolBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier:"AHMainViewController", sender: nil)
    }
    
    @IBAction func menuToolBtnAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.1
        transition.type = kCATransition
        transition.subtype = kCATransitionFromBottom
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
           print(" DEALOCK MEMORY")
        super.didReceiveMemoryWarning()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AUPSettingViewController
        {
            print(" prepare AUPSettingViewController")

            let aupsetting = segue.destination as? AUPSettingViewController
            aupsetting!.profileObj = self.profileObj!
        }
        else if segue.destination is SettingAddressUserViewController
        {
            let setupAccessUser = segue.destination as? SettingAddressUserViewController
            setupAccessUser?.typeAddressChange = typeAddressChange
            //addressUserArray = jsonAccountFinal!["address"] as? [String:Any]
            //setupAccessUser?.addressUserArray = addressUserArray
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
                }
                UIView.transition(with: self.view,
                                  duration:0.1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.settingTable.reloadData()
                                    self.activityActionStop()},
                                  completion: nil)
                

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


extension AUSettingViewController : UITableViewDataSource, UITableViewDelegate{
    
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
                    imagePersonalView.image = UIImage(named: GlobalVariables.sharedManager.profileImageDefault)
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
                
                if profileObj!.address != nil {
                    for address in profileObj!.address! {
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
                
                if profileObj!.address != nil {
                    for address in profileObj!.address! {
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
            self.performSegue(withIdentifier:"AUPSettingViewController", sender: nil)
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
