//
//  EditAccountUserViewController.swift
//  PackSendMe
//
//  Created by Ricardo Marzochi on 16/12/2018.
//  Copyright © 2018 Ricardo Marzochi. All rights reserved.
//

import UIKit

class SettingProfileUserViewController: UIViewController {

    @IBOutlet weak var userprofileTable: UITableView!
    @IBOutlet weak var photoprofileBtn: UIButton!
    @IBOutlet weak var editAccessInfTitleLabel: UILabel!
    @IBOutlet weak var useraccountLabel: UILabel!

    var accountModel : AccountDto? = nil
    var countryModel : CountryModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countryModel = CountryModel(countryImage: GlobalVariables.sharedManager.countryImageInstance!, name: GlobalVariables.sharedManager.countryNameInstance, cod: GlobalVariables.sharedManager.countryCodInstance, format: GlobalVariables.sharedManager.countryFormatInstance)

        
        
        editAccessInfTitleLabel.text = NSLocalizedString("setting-title-home", comment:"")
        userprofileTable.rowHeight = UITableViewAutomaticDimension
        userprofileTable.isScrollEnabled = true
        userprofileTable.translatesAutoresizingMaskIntoConstraints = false
        useraccountLabel.text = accountModel?.name
        
     //   photoprofileBtn.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        photoprofileBtn.layer.cornerRadius = 0.5 * photoprofileBtn.bounds.size.width
        photoprofileBtn.clipsToBounds = true
       // photoprofileBtn.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
        
        // Load Image Profile
        if UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as? NSData != nil{
            let dataImage = UserDefaults.standard.object(forKey: GlobalVariables.sharedManager.profileImage) as! NSData
            let profileImage = UIImage(data: dataImage as Data)
            photoprofileBtn.setImage(profileImage, for: .normal)
        }
        else{
            let dataImage = UIImage(named: GlobalVariables.sharedManager.profileImageDefault)
            photoprofileBtn.setImage(dataImage, for: .normal)
        }
        userprofileTable.delegate = self
        userprofileTable.dataSource = self
    }
    
    
    @IBAction func hometoolAction(_ sender: Any) {
        self.performSegue(withIdentifier:URLConstants.ACCOUNT.allViewToAccountHomeView, sender: nil)
    }
    
    @IBAction func menutoolAction(_ sender: Any) {
    }
    
    @IBAction func photoProfileAction(_ sender: Any){
        self.performSegue(withIdentifier:"PhotoProfileViewControllerGo", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier	== "PhotoProfileViewControllerGo"{
            let setupPhotoProfile = segue.destination as? PhotoProfileViewController
            setupPhotoProfile?.accountModel = accountModel
        }
        if segue.identifier == "ManagerProfileUserViewControllerGoName"{
            let setupUserProfile = segue.destination as? ManagerProfileUserViewController
            setupUserProfile?.accountModel = accountModel
            setupUserProfile?.metadadosView = URLConstants.IAM.nameUI
        }
        if segue.identifier == "ManagerProfileUserViewControllerGoEmail"{
            let setupUserProfile = segue.destination as? ManagerProfileUserViewController
            setupUserProfile?.accountModel = accountModel
            setupUserProfile?.metadadosView = URLConstants.IAM.emailUI
        }
        if segue.identifier == "ManagerProfileUserViewControllerGoPassword"{
            let setupUserProfile = segue.destination as? ManagerProfileUserViewController
            setupUserProfile?.accountModel = accountModel
            setupUserProfile?.metadadosView = URLConstants.IAM.passwordUI
        }
        if segue.identifier == "ManagerProfileUserViewControllerGoUsername"{
            let setupUserProfile = segue.destination as? ManagerUsernamePhoneViewController
            setupUserProfile?.countryModel = countryModel
            //setupUserProfile?.metadadosView = URLConstants.IAM.usernameUI
        }
    }

}

extension SettingProfileUserViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0;//Choose your custom row height
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var country = countriesData[indexPath.section][indexPath.row]
        
       guard let cell = tableView.dequeueReusableCell(withIdentifier:"AccessInfoCell") as? ProfileUserViewCell
            else{
                return UITableViewCell()
       }
       
       if indexPath.row == 0{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-name", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.name
       }
       else if indexPath.row == 1{
            //cell.nameFieldUserLabel.font = UIFont(name:"Avenir", size:19)
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-lastname", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.lastName
       }
       else if indexPath.row == 2{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-email", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.email
       }
       else if indexPath.row == 3{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-password", comment:"")
            cell.itemFieldUserLabel.text =  String("123456781234567812345678".characters.map { _ in return "•" })
            //cell.itemFieldUserLabel.text = accountModel?.password
        
       }
       else if indexPath.row == 4{
            cell.nameFieldUserLabel.text = NSLocalizedString("profileuser-title-numberphone", comment:"")
            cell.itemFieldUserLabel.text = accountModel?.username
       }
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if indexPath.row == 0{
           self.performSegue(withIdentifier:"ManagerProfileUserViewControllerGoName", sender: nil)
       }
       else if indexPath.row == 1{
           self.performSegue(withIdentifier:"ManagerProfileUserViewControllerGoName", sender: nil)
       }
       else if indexPath.row == 2{
            self.performSegue(withIdentifier:"ManagerProfileUserViewControllerGoEmail", sender: nil)
       }
       else if indexPath.row == 3{
            self.performSegue(withIdentifier:"ManagerProfileUserViewControllerGoPassword", sender: nil)
       }
       else if indexPath.row == 4{
            self.performSegue(withIdentifier:"ManagerProfileUserViewControllerGoUsername", sender: nil)
       }
    }
}

